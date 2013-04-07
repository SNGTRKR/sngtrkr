class DropTable < ActiveRecord::Migration
  def self.up
  	drop_table :reports
  end

  def down
  end
end
