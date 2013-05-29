class DropTracksAndMore < ActiveRecord::Migration
  def up
    drop_table :tracks
    drop_table :rates
    drop_table :manages
    drop_table :super_manages
  end

  def down
  end
end
