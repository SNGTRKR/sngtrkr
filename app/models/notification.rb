class Notification < ActiveRecord::Base

  belongs_to :release
  belongs_to :user

  scope :sent, -> {where(sent: true)}
  scope :unsent, -> {where(sent: false)}

  def mark_as_sent!
    self.sent = true
    self.sent_at = Time.now
    self.save
  end

end
