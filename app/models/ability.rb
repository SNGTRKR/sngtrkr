class Ability
  include CanCan::Ability
  include Devise
  def initialize(user)
    # Logged in user permissions
    if !user.blank?
      can :manage, [User, Rate, Manage]
      can [:edit, :scrape_confirm], [Artist]
      can :create, [Feedback]
    end
    
    # Guest user permissions
    user ||= User.new
    can :read, [Artist, Release] 
    
    # Admin permissions
    if user.role? :admin
      can :manage, :all
      can :read, :rails_admin       # only allow admin users to access Rails Admin
      can :manage, Resque
    else
      
    end
  end
end