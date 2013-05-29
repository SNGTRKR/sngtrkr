class IndexBooleans < ActiveRecord::Migration
  def up
    add_index :releases, [:ignore, :upc]
    add_index :artists, [:ignore]
  end

  def down
  end
end
