class AddCifToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :cif, :text
  end

  def self.down
    remove_column :clients, :cif
  end
end
