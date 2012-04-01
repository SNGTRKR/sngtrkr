class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.text :bio
      t.string :website
      t.string :twitter
      t.string :facebook
      t.string :sdigital

      t.timestamps
    end
  end
end
