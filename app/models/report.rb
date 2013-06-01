class Report < ActiveRecord::Base
  attr_accessible :comments, :elements, :url, :user_id, :release
  belongs_to :user
  default_scope :order => :created_at
  serialize :elements
  validates :comments, :presence => true

end
