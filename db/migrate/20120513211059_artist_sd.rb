class ArtistSd < ActiveRecord::Migration
  def up
    change_table :artists do |t|
      t.text :sd
    end
  end

  def down
  end
end
