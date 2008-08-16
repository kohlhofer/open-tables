require 'feed_tools'
require 'hpricot'

class Feed < ActiveRecord::Base
  has_many :items, :dependent => :delete_all
  belongs_to :topic
  
  validates_presence_of :title
  validates_presence_of :url
  belongs_to :user
  
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
      :feed => self
      )
    article.topics << self.topic if self.topic
  end
  
  def create_weblink(item)
    return if Weblink.find_by_source(item.link)
    weblink = Weblink.create!(
      :body => item.description,
      :source => item.link,
      :published => true,
      :title => item.title,
      :feed => self,
      :tag_list => item.categories.collect{|c| c.term }.join(',')
      )

    weblink.topics << self.topic if self.topic
  end
  
  def create_flickr(item)
    return if Photo.find_by_source(item.link)
    photo = Photo.create!(
      :title => item.title,
      :source => item.link,
      :body => item.media_thumbnail_link)
  end
end
