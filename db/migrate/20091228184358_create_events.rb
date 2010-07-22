class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :client_id
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.text :address
      t.integer :resources
      t.string :name
      t.integer :assignments_accepted, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
