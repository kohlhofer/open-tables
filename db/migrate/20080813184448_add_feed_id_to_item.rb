class AddFeedIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :feed_id, :integer
  end

  def self.down
    remove_column :items, :feed_id
  end
end
