class ArtistIgnore2 < ActiveRecord::Migration
  def up
    alter_table :artists do |t|
      t.boolean :ignore
    end
  end

  def down
  end
end
