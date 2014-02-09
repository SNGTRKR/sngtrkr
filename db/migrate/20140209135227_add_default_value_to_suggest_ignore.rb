class AddDefaultValueToSuggestIgnore < ActiveRecord::Migration
  def change
    change_column :suggests, :ignore, :boolean, :default => false
  end
end
