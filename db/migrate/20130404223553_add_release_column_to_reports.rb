class AddReleaseColumnToReports < ActiveRecord::Migration
  def change
    add_column :reports, :release, :string
  end
end
