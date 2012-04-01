class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :releases, :type, :rls_type
  end

  def down
  end
end
