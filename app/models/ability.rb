class Ability
  include CanCan::Ability
  include Devise
  def initialize(user)
    # Logged in user permissions
    if !user.blank? and user.role? :user
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
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard              # grant access to the dashboard
      can :manage, Resque
    else
      
    end
  end
end