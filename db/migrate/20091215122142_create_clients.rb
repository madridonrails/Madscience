class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.text :address
      t.string :mail
      t.string :phone
      t.string :contact

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
