class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :release_id
      t.integer :user_id

      t.timestamps
    end
  end
end
