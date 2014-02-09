# Suggest Documentation
#
# The suggest table is a HABTM relationship handler between the artists and users tables.
# Suggests are generated after a user is created from various sources.

# == Schema Information
#
# Table name: suggests
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  artist_id          :integer      
#  ignore             :boolean          default(false)    
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Suggest < ActiveRecord::Base

  attr_accessible :user_id, :artist_id

  belongs_to :artist
  belongs_to :user

  validates :user_id,                 :presence => true, :uniqueness => { :scope => :artist_id }
  validates :artist_id,               :presence => true            

  before_save :default_values
  before_create :check_not_following

  scope :relevant, -> { where(ignore: false) }

  def default_values
    # Don't ignore new suggestions
    self.ignore ||= false
    true
  end

  def check_not_following
    if Follow.where(:user_id => user_id, :artist_id => artist_id).count > 0
      return false
    end
  end

  def self.search(user_id, artist_id)
    self.relevant.find(:all, :conditions => ["user_id = '#{user_id}' AND artist_id = '#{artist_id}'"])
  end

  def self.generate_new_suggests
    User.all.each do |user|
      if user.suggested_artists.count < 24
        # FIXME: This seems very resource intensive - needs to be shortened and efficient
        follows = Artist.joins(:follows).where('user_id = ?',user.id).pluck(:id)
        suggests = user.suggested_artists.pluck(:id)
        artists = Artist.where("artists.id NOT IN (?)", follows + suggests).limit(12)
        binding.pry
        puts "#{user.id} - #{artists.count}"
        artists.each do |artist|
          puts "#{artist.id} #{artist.name}"
          Suggest.create(:user_id => user.id, :artist_id => artist.id)
        end
        puts user.suggested_artists.count
      end
    end
  end

  #TODO: It would seem when moving databases around, somewhere along the line, a lot of the suggested artists for users were already being followed by the user. This method quickly removed any rouge suggests.
  def self.remove_redundant_suggests
    User.all.each do |user|
      @follows = Follow.where(:user_id => user.id).all
      @follows.each do |follow|
        Suggest.where(:user_id => follow.user_id, :artist_id => follow.artist_id).destroy_all
      end
    end
  end

end
