class Manage < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  validates :user_id, :presence => true
  validates :artist_id, :presence => true
  def self.search(user_id, artist_id)
    find(:all, :conditions => ["user_id = '#{user_id}' AND artist_id = '#{artist_id}'"])
  end

  def self.user_managing(user_id)
    find(:all, :conditions => ["user_id = '#{user_id}'"])
  end

end
