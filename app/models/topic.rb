class Topic < ActiveRecord::Base
  has_and_belongs_to_many :topics
end
