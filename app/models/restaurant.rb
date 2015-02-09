class Restaurant < ActiveRecord::Base
	
	#relations
	has_many :branches , dependent: :destroy
	belongs_to :user 
	#scopes
	scope :by_user, lambda { |user| where("restaurants.user_id = ?",user) }
	scope :published, lambda { where("restaurants.status = 1") }
	#validations
	validates :title,		:presence => true,
							:length => { :maximum => 25 }

	validates :slug, 		:uniqueness => true,
							:presence => true
					

end
