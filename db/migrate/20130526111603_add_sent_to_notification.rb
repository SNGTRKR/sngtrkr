class AddSentToNotification < ActiveRecord::Migration
  def change
  	change_table :notifications do |t|
	  	t.boolean :sent, :default => false
	  	t.datetime :sent_at
	  end
  end
end
