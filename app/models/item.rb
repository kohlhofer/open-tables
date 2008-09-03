class Item < ActiveRecord::Base
  has_and_belongs_to_many :topics
  belongs_to :feed
  validates_presence_of :title
  
  named_scope :published, :conditions => {:published => true}, :order => 'updated_at DESC'
  acts_as_taggable
  
  def next(topic = nil)
    if topic
      topic.items.published.find(:first, :conditions => ['id < ?', self.id], :order => 'id DESC', :limit => 1)
    else
      self.class.published.find(:first, :conditions => ['id < ?', self.id], :order => 'id DESC', :limit => 1)
    end
  end
  def previous(topic = nil)
    if topic
      topic.items.published.find(:first, :conditions => ['id > ?', self.id], :order => 'id DESC', :limit => 1)
    else
      self.class.published.find(:first, :conditions => ['id > ?', self.id], :order => 'id DESC', :limit => 1)
    end
  end

  def preview_url
    false
  end

  def source_short
    begin
      self.source.gsub(/https?:\/\//, '').gsub(/\/$/, '')
    rescue Exception => ex
      'none'
    end
  end

  def toggle_relevant(tag)
    self.tag_list.add(tag)
    self.tag_list.remove(tag == 'relevant' ? 'rejected' : 'relevant')
  end
  def filtered_tags
    return tags.reject{|tag| ['relevant', 'rejected'].include?(tag.to_s) }
  end

  def before_validation
    self.topics.uniq!
  end

  def type_name
    return type.to_s
  end
  def type_name=(klass)
    self[:type] = klass
  end
  
  def rejected?
    self.tag_list.include?('rejected')
  end
  def relevant?
    self.tag_list.include?('relevant')
  end
  def rejected_or_relevant
    return 'rejected' if rejected?
    return 'relevant' if relevant?
    return false
  end
end
