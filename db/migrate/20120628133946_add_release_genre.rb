class AddReleaseGenre < ActiveRecord::Migration
  def up
    change_table :releases do |t|
      t.text :genre
    end
  end

  def down
  end
end
