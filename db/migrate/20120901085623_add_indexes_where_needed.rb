class AddIndexesWhereNeeded < ActiveRecord::Migration
  def up
    add_index :releases, [:date,:itunes_id,:sd_id,:artist_id]
    add_index :artists, [:itunes_id,:sdid]
  end

  def down
  end
end
