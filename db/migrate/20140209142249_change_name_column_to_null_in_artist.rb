class ChangeNameColumnToNullInArtist < ActiveRecord::Migration
  def change
    change_column :artists, :name, :string, :null => true
  end
end
