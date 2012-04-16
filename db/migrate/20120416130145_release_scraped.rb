class ReleaseScraped < ActiveRecord::Migration
  def up
    alter_table :releases do |t|
      t.integer :scraped
    end
  end

  def down
  end
end
