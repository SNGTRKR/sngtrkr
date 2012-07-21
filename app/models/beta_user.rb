class BetaUser < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, :message => "is not a valid email address."

  before_save :default_values

  # Identify an email as a beta registrant who registered before the given deadline
  def self.beta_user?(email, deadline)
    if where(:email => email).where("created_at < ?",deadline).empty?
      return false
    else
      return true
    end
  end

  def default_values
    self.emailed ||= false
    return true
  end


end
