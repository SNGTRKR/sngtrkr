class Suggest < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  validates :user_id, :presence => true
  validates :artist_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :artist_id}

  after_initialize :default_values
  def default_values
    # Don't ignore new suggestions
    self.ignore ||= false
    self.save
  end

  def self.search(user_id, artist_id)
    self.find(:all, :conditions => ["user_id = '#{user_id}' AND artist_id = '#{artist_id}' AND suggests.ignore = ?",false])
  end

  def self.user_suggested(user_id)
    self.find(:all, :conditions => ["user_id = '#{user_id}' AND suggests.ignore = ?",false])
  end

end
