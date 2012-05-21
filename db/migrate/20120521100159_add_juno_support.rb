class AddJunoSupport < ActiveRecord::Migration
  def up
    change_table :artists do |t|
      t.text :juno
    end
    change_table :releases do |t|
      t.text :juno
    end
  end

  def down
  end
end
