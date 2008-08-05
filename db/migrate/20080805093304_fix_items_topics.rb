class FixItemsTopics < ActiveRecord::Migration
  def self.up
    remove_column :items_topics, :id
  end

  def self.down
  end
end
