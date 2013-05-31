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

    if user.roles.map{|r| r.name }.include? "Admin"
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
    can :manage, [User, Timeline]
    can :destroy, [Suggest]
    can [:edit, :scrape_confirm], [Artist]
    can [:edit, :previews, :create], Release

    can [:create, :destroy], [Follow]
    can :create, [Report]

    can :search, [Artist]
  end

  def admin_permissions(user)
    user_permissions(user)
    can :manage, :all
  end

end