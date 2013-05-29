class UndoPaperclip2Carrierwave < ActiveRecord::Migration
  def change
    rename_column :artists, :image, :image_file_name
    rename_column :releases, :image, :image_file_name
  end
end
