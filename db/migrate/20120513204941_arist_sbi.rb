class AristSbi < ActiveRecord::Migration
  def up
    change_table :artists do |t|
      t.text :sdid
    end
  end

  def down
  end
end
