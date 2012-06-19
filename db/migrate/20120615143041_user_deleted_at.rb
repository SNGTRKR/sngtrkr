class UserDeletedAt < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.date :deleted_at
    end
  end

  def down
  end
end
