class AdminTools
	def self.email_beta_users(deadline)
		users = BetaUser.where("created_at < ?",deadline).where(:emailed => false)
		users.each do |user|
			UserMailer.welcome_email(user)
		end
	end
end