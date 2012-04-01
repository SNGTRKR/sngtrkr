class CreateSuggests < ActiveRecord::Migration
  def change
    create_table :suggests do |t|
      t.integer :user_id
      t.integer :artist_id
      t.boolean :ignore

      t.timestamps
    end
  end
end
