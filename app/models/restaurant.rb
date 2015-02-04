class Restaurant < ActiveRecord::Base
	
	#relations
	has_many :branches , dependent: :destroy
	belongs_to :user 
	
	#validations
	validates :title,		:presence => true,
							:length => { :maximum => 25 }

	validates :slug, 		:uniqueness => true,
							:presence => true,
							:length => { :maximum => 25 }
					

end
