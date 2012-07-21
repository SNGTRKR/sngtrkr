class AddEmailedToBetaUsers < ActiveRecord::Migration
  def change
    add_column :beta_users, :emailed, :boolean

  end
end
