class ArtistAddItunes < ActiveRecord::Migration
  def up
    change_table :artists do |t|
      t.string :itunes
    end
  end

  def down
  end
end
