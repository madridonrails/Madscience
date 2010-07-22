class AddContactIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :contact_id, :integer
  end

  def self.down
    remove_column :events, :contact_id
  end
end
