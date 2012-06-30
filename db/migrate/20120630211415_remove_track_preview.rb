class RemoveTrackPreview < ActiveRecord::Migration
  def up
    remove_column :tracks, :preview
  end

  def down
  end
end
