class Branch < ActiveRecord::Base
	#sorting
	acts_as_list
	#relations
	has_many :reservations , dependent: :destroy
	belongs_to :restaurant
	
	#scopes
	scope :sorted, lambda { order("branches.position ASC") }
	scope :by_user, lambda { |user| where("branches.user_id = ?",user) }
	#scope :by_time, lambda{|time| where{""} }
	scope :published, lambda { where("branches.status = ?",true) }
	#constant
  	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
	#validations
	# validates :title,		:presence => true,
	# 						:length => { :maximum => 25 }

	validates :slug, 		:uniqueness => true,
							:presence => true

	# validates :position, 	:numericality => { :only_integer => true , :greater_than => 0 },
	# 						:presence => true
	validates :email, 		:presence => true, :format => EMAIL_REGEX	
	validates :seating_capacity, 		:presence => true,:numericality => { :only_integer => true , :greater_than => 0 }
	validates :expiry, 		:presence => true,:numericality => { :only_integer => true , :greater_than => 0 }
	validates :time_zone, 	:presence => true
	validates :phone,    :presence => true , :phone_number => {:ten_digits => true}
	
end
