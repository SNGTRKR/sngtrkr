class AddMoreIndexesWhereNeeded < ActiveRecord::Migration
  def up
    add_index :suggests, [:user_id,:artist_id]
    add_index :follows, [:user_id,:artist_id]
    add_index :manages, [:user_id,:artist_id]
    add_index :tracks, [:release_id]
    add_index :users, :fbid, :length => 20
  end

  def down
  end
end
