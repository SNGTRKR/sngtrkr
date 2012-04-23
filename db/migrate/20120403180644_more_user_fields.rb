class MoreUserFields < ActiveRecord::Migration
  def up
    alter_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :type
      t.integer :email_frequency
      t.datetime :last_email
      t.string :username
      t.integer :role
    end
  end

  def down
  end
end
