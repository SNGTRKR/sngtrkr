class Release < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true

  has_attached_file :image, :styles => { 
  :medium => "300x300>", 
  :thumb => "100x100>",
  :release => "210x210#" }

  has_many :tracks
  belongs_to :artist

end
