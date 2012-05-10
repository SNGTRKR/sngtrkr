class ArtistAddItunes < ActiveRecord::Migration
  def up
    alter_table :artists do |t|
      t.string :itunes
    end
  end

  def down
  end
end
