class Report < ActiveRecord::Base
  attr_accessible :comments, :elements, :url, :user_id, :release
  belongs_to :user
  default_scope :order => :created_at
  serialize :elements
  
  validates :comments, :presence => true


  def one_checkbox_selected
  	if elements.blank?
	  	errors.add_to_base("Please select at least one category.") 
	  end
  end
end
