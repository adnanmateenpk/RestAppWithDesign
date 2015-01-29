class Page < ActiveRecord::Base
	#sorting
	acts_as_list
	#relations
	belongs_to :layout
	#scopes
	scope :sorted, lambda { order("pages.position ASC") }

	#validations
	validates :title,		:presence => true,
							:length => { :maximum => 25 }

	validates :slug, 		:uniqueness => true,
							:presence => true,
							:length => { :maximum => 25 }

	validates :position, 	:numericality =>{:only_integer => true,:greater_than => 0},
							:presence => true,


	validates :layout_id, 	:numericality =>{:only_integer => true,:greater_than => 0},
							:presence => true

	
end
