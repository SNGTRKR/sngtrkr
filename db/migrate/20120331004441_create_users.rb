class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.integer :type
      t.string :email
      t.integer :email_frequency
      t.datetime :last_email
      t.string :username
      t.integer :role

      t.timestamps
    end
  end
end
