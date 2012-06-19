class Userleaving < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.integer :leave_reason
    end
  end

  def down
  end
end
