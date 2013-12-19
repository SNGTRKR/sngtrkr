class Follow < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  validates :user_id, :presence => true
  validates :artist_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :artist_id}

  after_create :delete_suggestion

  before_destroy :destroy_unfollowed_artist

  def destroy_unfollowed_artist
    if Follow.where("artist_id = ?", self.artist_id).count == 1
      artist.ignore = true
      artist.save
      artist.releases.destroy_all
      artist.suggests.delete_all
    end
  end

  def delete_suggestion
    Suggest.where(:user_id => user_id, :artist_id => artist_id).destroy_all
  end

end
