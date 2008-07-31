class ExtendItems < ActiveRecord::Migration
  def self.up
    add_column :items, :published, :boolean, :default => true, :null => false
    add_column :items, :spam, :boolean, :default => false, :null => false
    add_column :items, :user_id, :integer
  end

  def self.down
    remove_column :items, :user_id
    remove_column :items, :spam
    remove_column :items, :published
  end
end
