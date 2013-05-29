class ReleaseItunesId < ActiveRecord::Migration
  def up
    change_table :releases do |t|
      t.integer :itunes_id
    end
  end

  def down
  end
end
