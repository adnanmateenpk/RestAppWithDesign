class Setting < ActiveRecord::Base
	#constant
  	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	#validations
	validates :title,		:presence => true
	validates :email, 		:presence => true, :format => EMAIL_REGEX
end
