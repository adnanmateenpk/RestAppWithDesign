class Branch < ActiveRecord::Base
	#sorting
	acts_as_list
	#relations
	has_many :tables , dependent: :destroy
	belongs_to :restaurant
	#scopes
	scope :sorted, lambda { order("branches.position ASC") }
	#constant
  	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
	#validations
	validates :title,		:presence => true,
							:length => { :maximum => 25 }

	validates :slug, 		:uniqueness => true,
							:presence => true,
							:length => { :maximum => 25 }

	validates :position, 	:numericality => { :only_integer => true , :greater_than => 0 },
							:presence => true
	validates :email, 		:presence => true, :format => EMAIL_REGEX	
end
