class Item < ActiveRecord::Base
  has_and_belongs_to_many :topics
  validates_presence_of :title
  
  named_scope :published, :conditions => {:published => true}, :order => 'updated_at'
  acts_as_taggable

  def before_validation
    self.topics.uniq!
  end

  def type_name
    return type.to_s
  end
  def type_name=(klass)
    self[:type] = klass
  end
  
  def rejected_or_relevant
    return 'rejected' if self.tag_list.include?('rejected')
    return 'relevant' if self.tag_list.include?('relevant')
  end
end
