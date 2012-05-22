class Sdid < ActiveRecord::Migration
  def up
    change_table :tracks do |t|
      t.text :sd_id
    end
  end

  def down
  end
end
