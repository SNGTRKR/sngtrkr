class Ability
  include CanCan::Ability
  include Devise
  def initialize(user)
    if user.blank? or user.roles.empty?
      # Guest user permissions
      user ||= User.new
      guest_permissions(user)
    else
      # Logged in user permissions
      user_permissions(user)
    end
    
    if user.role? :admin
      # Admin permissions
      admin_permissions(user)
    end
  end
  
  def guest_permissions(user)
      can :read, [Artist, Release] 
      can :manage, User
  end
  
  def user_permissions(user)
    guest_permissions(user)
    can :read, [User]
    can :manage, [User, Rate, Manage]
    can :destroy, [Suggest]
    can [:edit, :scrape_confirm], [Artist]
    can [:edit, :previews, :create], Release

    can [:create, :destroy], [Follow]
    can :create, [Feedback]

    can :search, [Artist]
  end
  
  def admin_permissions(user)
    user_permissions(user)
    can :manage, :all
    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard
  end
  
end