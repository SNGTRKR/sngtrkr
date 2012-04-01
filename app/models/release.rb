class Release < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true
  
  has_many :tracks
  belongs_to :artist
end
