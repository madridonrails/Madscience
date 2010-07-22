class RemoveContactFromClient < ActiveRecord::Migration
  def self.up
    remove_column :clients, :contact
  end

  def self.down
    add_column :clients, :contact, :string
  end
end
