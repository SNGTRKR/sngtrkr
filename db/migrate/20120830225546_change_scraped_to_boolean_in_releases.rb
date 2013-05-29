class ChangeScrapedToBooleanInReleases < ActiveRecord::Migration
  def up
    change_table :releases do |t|
      t.change :scraped, :boolean
    end
  end

  def down
  end
end
