class TrackItunesPreview < ActiveRecord::Migration
  def up
    change_table :tracks do |t|
      t.text :itunes_preview
    end
  end

  def down
  end
end
