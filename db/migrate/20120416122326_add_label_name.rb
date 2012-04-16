class AddLabelName < ActiveRecord::Migration
  def up
    alter_table :artists do |t|
      t.text :label_name
    end
    alter_table :releases do |t|
      t.text :label_name
      t.integer :label_id
    end
  end

  def down
  end
end
