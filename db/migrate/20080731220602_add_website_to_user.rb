class AddWebsiteToUser < ActiveRecord::Migration
  def self.up
    add_column :goldberg_users, :website, :string
  end

  def self.down
    remove_column :goldberg_users, :website
  end
end
