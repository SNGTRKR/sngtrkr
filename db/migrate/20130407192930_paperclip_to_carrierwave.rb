class PaperclipToCarrierwave < ActiveRecord::Migration
  def change
  	rename_column :artists, :image_file_name, :image
  	rename_column :releases, :image_file_name, :image
  end
end
