class AddArtistColumnToReports < ActiveRecord::Migration
  def change
    add_column :reports, :artist, :string
  end
end
