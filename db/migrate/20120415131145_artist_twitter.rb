class ArtistTwitter < ActiveRecord::Migration
  def up
    alter_table :artists do |t|
      t.text :twitter
    end
  end

  def down
  end
end
