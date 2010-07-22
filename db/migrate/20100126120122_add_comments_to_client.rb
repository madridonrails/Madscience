class AddCommentsToClient < ActiveRecord::Migration
  def self.up
    add_column :clients, :comments, :text
  end

  def self.down
    remove_column :clients, :comments
  end
end
