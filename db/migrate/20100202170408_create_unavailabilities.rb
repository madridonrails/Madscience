class CreateUnavailabilities < ActiveRecord::Migration
  def self.up
    create_table :unavailabilities do |t|
      t.integer :user_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end

  def self.down
    drop_table :unavailabilities
  end
end
