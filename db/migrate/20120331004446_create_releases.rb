class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name
      t.datetime :date
      t.string :cat_no
      t.string :itunes
      t.string :sdigital
      t.string :amazon
      t.string :youtube
      t.integer :type
      t.integer :artist_id

      t.timestamps
    end
  end
end
