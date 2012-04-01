class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :genre
      t.text :bio
      t.string :hometown
      t.string :booking_email
      t.string :manager_email
      t.string :website
      t.string :soundcloud
      t.string :youtube
      t.integer :label_id

      t.timestamps
    end
  end
end
