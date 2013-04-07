class DropFeedback < ActiveRecord::Migration
  def self.up
  	drop_table :feedbacks
  end

  def down
  end
end
