class SensibleSanitisation < ActiveRecord::Migration
  def change
  	change_column :artists, :name, :string, :null => false
  	change_column :artists, :ignore, :boolean, :null => false, :default => false
  	
  	change_column :releases, :name, :string, :null => false
		change_column :releases, :date, :datetime, :null => false
		change_column :releases, :ignore, :boolean, :null => false, :default => false
		change_column :releases, :artist_id, :integer, :null => false

	end	
	
end
