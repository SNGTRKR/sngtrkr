# Follow Documentation
#
# The follow table is a HABTM relationship handler between the artists and users tables.
# A user can follow an artist and view their music content on the user's timeline.

# == Schema Information
#
# Table name: follows
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  artist_id          :integer          
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Follow < ActiveRecord::Base

  belongs_to :artist
  belongs_to :user

  validates :artist_id,                 :presence => true
  validates :user_id,                   :presence => true, :uniqueness => {:scope => :artist_id}

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
