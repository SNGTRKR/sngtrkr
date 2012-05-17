class Track < ActiveRecord::Base
  validates :name, :presence => true
  belongs_to :release
end
