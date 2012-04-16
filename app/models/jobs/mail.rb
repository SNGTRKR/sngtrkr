class Mail
  @queue = :mail;
  def self.perform 
    # Send emails to users.
  end
end
