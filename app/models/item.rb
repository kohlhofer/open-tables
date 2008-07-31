class Item < ActiveRecord::Base
  has_and_belongs_to_many :topics
  validates_presence_of :title
  
  named_scope :published, :conditions => {:published => true}, :order => 'updated_at'
  acts_as_taggable

  def type_name
    return type.to_s
  end
  def type_name=(klass)
    self[:type] = klass
  end
end
