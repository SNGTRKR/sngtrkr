class DropLabels < ActiveRecord::Migration
  def up
  	drop_table :labels
  	remove_column :releases, :label_id
  	remove_column :artists, :label_id
  end

  def down
  end
end
