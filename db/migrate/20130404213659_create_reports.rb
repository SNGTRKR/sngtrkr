class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.text :comments
      t.string :url
      t.string :elements

      t.timestamps
    end
  end
end
