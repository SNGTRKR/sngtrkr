class AddTrackPreview < ActiveRecord::Migration
  def up
    change_table :tracks do |t|
      t.text :preview
    end
  end

  def down
  end
end
