class RemoveAttributesFromRelease < ActiveRecord::Migration
  def change
    remove_column :releases, :rls_type
    remove_column :releases, :sd_id
    remove_column :releases, :image_file_name
    remove_column :releases, :image_content_type
    remove_column :releases, :image_file_size
    remove_column :releases, :image_updated_at
    remove_column :releases, :upc
    remove_column :releases, :image_source
    remove_column :releases, :image_last_attempt
    remove_column :releases, :image_attempts
    change_column :releases, :juno, :string
    change_column :releases, :genre, :string
  end
end
