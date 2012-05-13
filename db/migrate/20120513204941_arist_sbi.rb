class AristSbi < ActiveRecord::Migration
  def up
    alter_table :artists do |t|
      t.text :sdid
    end
  end

  def down
  end
end
