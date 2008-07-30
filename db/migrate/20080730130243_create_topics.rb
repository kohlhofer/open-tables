class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.column :title, :string, :null => false, :unique => true
      t.column :active, :boolean, :default => true

      t.timestamps
    end
    
    create_table :items_topics do |t|
      t.column :item_id, :integer, :null => false
      t.column :topic_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :topics
    drop_table :items_topics
  end
end
