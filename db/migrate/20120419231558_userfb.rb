class Userfb < ActiveRecord::Migration
  def up
    alter_table :users do |t|
      t.text :fbid
    end

  end

  def down
  end
end
