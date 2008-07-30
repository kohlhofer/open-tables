class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.column :type, :string, :null => false
      t.column :title, :string
      t.column :source, :string
      t.column :body, :text

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
