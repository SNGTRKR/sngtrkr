class DropBetaUsers < ActiveRecord::Migration
  def up
    drop_table :beta_users
  end

  def down
  end
end
