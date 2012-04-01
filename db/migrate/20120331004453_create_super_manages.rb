class CreateSuperManages < ActiveRecord::Migration
  def change
    create_table :super_manages do |t|
      t.integer :user_id
      t.integer :label_id

      t.timestamps
    end
  end
end
