class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.text :name
      t.text :sd_preview

      t.timestamps
    end
  end
end
