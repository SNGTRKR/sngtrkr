class AddTweetColumnToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :tweet, :boolean
  end
end
