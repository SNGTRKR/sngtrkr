class Label < ActiveRecord::Base

  has_many :artists
  has_many :super_manager_users, :through => :super_manage, :source => :user

end
