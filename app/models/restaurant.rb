class Restaurant < ActiveRecord::Base
	
	#relations
	has_many :branches , dependent: :destroy
	has_many :tables , dependent: :destroy
	belongs_to :user 
	#scopes
	scope :by_user, lambda { |user| where("restaurants.user_id = ?",user) }
	scope :published, lambda { where("restaurants.status = ?",true) }
	#validations
	validates :title,		:presence => true,
							:length => { :maximum => 25 }

	validates :slug, 		:uniqueness => true,
							:presence => true
					
	validates :user_id, :presence => true,:numericality => { :only_integer => true , :greater_than => 0 }						
end
