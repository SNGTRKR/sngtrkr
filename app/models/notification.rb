class Notification < ActiveRecord::Base
  
  belongs_to :release
  belongs_to :user
  
  def mark_as_sent!
  	self.sent = true
  	self.sent_at = Time.now
  	self.save
  end
  
end
