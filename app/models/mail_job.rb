class MailJob
  @queue = :mailjob;
  def self.perform 
    # Send emails to users.
  end
end
