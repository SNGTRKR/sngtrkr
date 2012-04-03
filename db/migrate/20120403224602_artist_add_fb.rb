class ArtistAddFb < ActiveRecord::Migration
  def up
    alter_table :artists do |t|
      t.string :fbid
    end
  end

  def down
  end
end
