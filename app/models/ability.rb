class Ability
  include CanCan::Ability
  include Devise
  def initialize(user)
    if user.blank? or user.roles.empty?
      # Guest user permissions
      user ||= User.new
      guest_permissions(user)
    elsif user.role? :user
      # Logged in user permissions
      user_permissions(user)
    elsif user.role? :admin
      # Admin permissions
      admin_permissions(user)
    else
      
    end
  end
  
  def guest_permissions(user)
      can :read, [Artist, Release] 
  end
  
  def user_permissions(user)
    guest_permissions(user)
    can :read, [User]
    can :manage, [User, Rate, Manage]
    can [:edit, :scrape_confirm], [Artist]
    can :create, [Feedback]
    can :search, [Artist]
  end
  
  def admin_permissions(user)
    user_permissions(user)
    can :manage, :all
    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard
    can :manage, Resque
  end
  
end