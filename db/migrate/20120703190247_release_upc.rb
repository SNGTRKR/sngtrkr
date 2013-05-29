class ReleaseUpc < ActiveRecord::Migration
  def up
    change_table :releases do |t|
      t.integer :upc
    end
  end

  def down
  end
end
