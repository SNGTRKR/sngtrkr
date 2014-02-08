class ChangeArtistAttributeDataTypes < ActiveRecord::Migration
  def change
    change_column :artists, :sd, :string
    rename_column :artists, :sd, :sdigital
    change_column :artists, :juno, :string
    change_column :artists, :label_name, :string
    change_column :artists, :twitter, :string
  end
end
