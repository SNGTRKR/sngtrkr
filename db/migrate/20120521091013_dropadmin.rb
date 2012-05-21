class Dropadmin < ActiveRecord::Migration
  def up
    remove_column :users, :admin
  end

  def down
  end
end
