class Topic < ActiveRecord::Base
  has_and_belongs_to_many :items
  validates_uniqueness_of :title
  
  named_scope :active, :conditions => {:active => true}

end
