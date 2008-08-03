class AddDescriptionToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :description, :text, :default => ''
  end

  def self.down
    remove_column :topics, :description
  end
end
