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
    feed.items.each do |item|
      send('create_%s' % self.factory, item)
    end
  end
  
  def create_article(item)
    return if Article.find_by_source(item.link)
    content = ""
    content = item.description unless item.description.blank?
    content += item.content unless item.content.blank? or item.content == item.description
    parsed_content = Hpricot.parse(content)
    # removing feedburner garbage
    parsed_content.search('/div.feedflare').remove
    parsed_content.search('/img[@src.match/^http://feeds.feedburner.com/~r/]').remove

    article = Article.create(
  #        :author => item.author.name,
      :body => parsed_content.to_s,
      :source => item.link,
      :published => item.published,
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
      :feed => self
      )

    weblink.topics << self.topic if self.topic
  end
end
