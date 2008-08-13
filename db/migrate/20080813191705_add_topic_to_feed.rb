class AddTopicToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :topic_id, :integer
  end

  def self.down
    remove_column :feeds, :topic_id
  end
end
