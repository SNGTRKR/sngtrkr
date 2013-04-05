class Sdid < ActiveRecord::Migration
  def up
    change_table :tracks do |t|
      t.text :sd_id
 	drop_table :reports
    end
  end

  def down
  end
end
