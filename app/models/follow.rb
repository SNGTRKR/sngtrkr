class Follow < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  validates :user_id, :presence => true
  validates :artist_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :artist_id}

  after_create :delete_suggestion

  before_destroy :destroy_unfollowed_artist

  def delete_suggestion
    Suggest.where(:user_id => user_id, :artist_id => artist_id).destroy_all
  end

  def self.search(user_id, artist_id)
    find(:all, :conditions => ["user_id = '#{user_id}' AND artist_id = '#{artist_id}'"])
  end

  def self.user_follows(user_id)
    find(:all, :conditions => ["user_id = '#{user_id}'"])
  end

  def destroy_unfollowed_artist
    if Follow.where("artist_id = ?",self.artist_id).count == 1
      artist.destroy
    end
  end


end
