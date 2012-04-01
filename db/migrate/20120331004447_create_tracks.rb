class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.integer :number
      t.integer :release_id

      t.timestamps
    end
  end
end
