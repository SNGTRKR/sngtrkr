class RemoveAttributesFromArtist < ActiveRecord::Migration
  def change
    remove_column :artists, :sdid
    remove_column :artists, :image_file_name
    remove_column :artists, :image_content_type
    remove_column :artists, :image_file_size
    remove_column :artists, :image_updated_at
    remove_column :artists, :itunes
  end
end
