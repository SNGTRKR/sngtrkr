class SuperManage < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  validates :user_id, :uniqueness => {:scope => :artist_id}

end
