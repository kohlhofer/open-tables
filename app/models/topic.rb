class Topic < ActiveRecord::Base
  has_and_belongs_to_many :items, :order => 'items.id DESC'

  validates_uniqueness_of :title
  
  named_scope :active, :conditions => {:active => true}
  acts_as_taggable

end
