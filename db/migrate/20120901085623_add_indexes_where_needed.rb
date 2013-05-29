class AddIndexesWhereNeeded < ActiveRecord::Migration
  def up
    add_index :releases, [:date, :artist_id]
  end

  def down
  end
end
