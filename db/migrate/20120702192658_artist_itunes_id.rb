class ArtistItunesId < ActiveRecord::Migration
  def up
    change_table :artists do |t|
      t.integer   :itunes_id
    end 
  end

  def down
  end
end
