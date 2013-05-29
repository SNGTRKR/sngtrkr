class IgnoreRelease < ActiveRecord::Migration
  def up
    change_table :releases do |t|
      t.boolean :ignore
    end
  end

  def down
  end
end
