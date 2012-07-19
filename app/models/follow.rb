class Follow < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  validates :user_id, :presence => true
  validates :artist_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :artist_id}

  after_create :delete_suggestion

  def delete_suggestion
    Suggest.where(:user_id => user_id, :artist_id => artist_id).destroy_all
  end

  def self.search(user_id, artist_id)
    find(:all, :conditions => ["user_id = '#{user_id}' AND artist_id = '#{artist_id}'"])
  end

  def self.user_follows(user_id)
    find(:all, :conditions => ["user_id = '#{user_id}'"])
  end


end
