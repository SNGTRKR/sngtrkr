class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new # guest user
    #can :access, nil                   # allow everyone to read everything
    #can :manage, :all
    #can :access, :all
    if user.role? :admin
      can :manage, :all
      can :access, :rails_admin       # only allow admin users to access Rails Admin
      can :manage, Resque
    end
  end
end