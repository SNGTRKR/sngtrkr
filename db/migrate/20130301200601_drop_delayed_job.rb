class DropDelayedJob < ActiveRecord::Migration

  def up
    drop_table :delayed_jobs
  end
end
