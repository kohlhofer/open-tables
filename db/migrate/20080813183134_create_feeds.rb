class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string   "title", :null => false
      t.text     "url", :limit => 512, :null => false
      t.text     "alternative_url"
      t.string   "factory", :default => "article"
      t.integer  "user_id"
      t.boolean  "active", :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
