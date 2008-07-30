class Item < ActiveRecord::Base
  has_and_belongs_to_many :topics
  validates_presence_of :title
end
