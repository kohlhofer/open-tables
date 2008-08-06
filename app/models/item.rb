class Item < ActiveRecord::Base
  has_and_belongs_to_many :topics
  validates_presence_of :title
  
  named_scope :published, :conditions => {:published => true}, :order => 'updated_at'
  acts_as_taggable


  def source_short
    self.source.gsub(/https?:\/\//, '').gsub(/\/$/, '')
  end

  def toggle_relevant(tag)
    self.tag_list.add(tag)
    self.tag_list.remove(tag == 'relevant' ? 'rejected' : 'relevant')
  end
  def filtered_tags
    return tags
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
