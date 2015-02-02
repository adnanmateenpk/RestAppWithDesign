class Restaurant < ActiveRecord::Base
	
	#relations
	has_many :branches
	
	
	#validations
	validates :title,		:presence => true,
							:length => { :maximum => 25 }

	validates :slug, 		:uniqueness => true,
							:presence => true,
							:length => { :maximum => 25 }
					

end
