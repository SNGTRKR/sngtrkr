class RemoveColumns < ActiveRecord::Migration
  def up
    remove_column :reports, :artist
  end

  def down
  end
end
