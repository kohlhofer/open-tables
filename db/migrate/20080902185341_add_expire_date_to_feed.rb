class AddExpireDateToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :expire_date, :datetime
  end

  def self.down
    remove_column :feeds, :expire_date
  end
end
