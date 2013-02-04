class AddImageSourceToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :image_source, :text
    add_column :releases, :image_last_attempt, :datetime
    add_column :releases, :image_attempts, :int
  end
end
