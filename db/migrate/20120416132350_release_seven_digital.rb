class ReleaseSevenDigital < ActiveRecord::Migration
  def up
    alter_table :releases do |t|
      t.text :sd_id
    end
  end

  def down
  end
end
