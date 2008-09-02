require 'feed_tools'
require 'hpricot'

class Feed < ActiveRecord::Base
  has_many :items, :dependent => :delete_all
  belongs_to :topic
  
  validates_presence_of :title
  validates_presence_of :url
  belongs_to :user
  acts_as_taggable
  
  named_scope :ordered, :order => 'feeds.topic_id, feeds.expire_date DESC', :include => :topic
  named_scope :active, :conditions => ['feeds.expire_date < NOW()']
  
  def refresh
    feed = FeedTools::Feed.open(self.url)
    feed.items.reverse.each do |item|
      send('create_%s' % self.factory, item)
    end
  end
  
  def create_article(item)
    return if Article.find_by_source(item.link)
    content = ""
    content = item.description unless item.description.blank?
    content += item.content unless item.content.blank? or item.content == item.description
  
    article = Article.create(
      :body => content,
      :source => item.link,
      :published => true,
      :title => item.title,
      :tag_list => get_tag_list(item),
      :feed_id => id
      )
    article.topics << self.topic if self.topic
  end
  
  def create_weblink(item)
    return if Weblink.find_by_source(item.link)
    weblink = Weblink.create(
      :body => item.description,
      :source => item.link,
      :published => true,
      :title => item.title || 'untitled',
      :tag_list => get_tag_list(item),
      :feed_id => id
      )
    weblink.topics << self.topic if self.topic
  end
  
  def create_flickr(item)
    return if Photo.find_by_source(item.link)
    photo = Photo.create(
      :title => item.title || 'untitled',
      :source => item.link,
      :published => true,
      :body => item.media_thumbnail_link.gsub(/_s\.jpg/, '.jpg'),
      :tag_list => get_tag_list(item),
      :feed_id => id)
    photo.topics << self.topic if self.topic
  end
  
  def create_youtube(item)
    return if Video.find_by_source(item.link)
    video = Video.create(
      :title => item.title || 'untitled',
      :source => item.link,
      :body => item.description,
      :published => true,
      :tag_list => get_tag_list(item),
      :feed_id => id)
    video.topics << self.topic if self.topic
  end
  
  def get_tag_list(item)
    return self.tag_list unless item.categories
    item.categories.collect{|c| c.term.split(' ') }.join(',')
  end
end
