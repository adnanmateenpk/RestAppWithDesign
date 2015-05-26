class DateRestriction < ActiveRecord::Base
	belongs_to :restaurant

	validates :restricted_date,		:presence => true
	validates :restaurant_id, :presence => true,:numericality => { :only_integer => true , :greater_than => 0 }	

		
end
