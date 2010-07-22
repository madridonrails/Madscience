class AddCodeToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :code, :string
  end

  def self.down
    remove_column :events, :code
  end
end
