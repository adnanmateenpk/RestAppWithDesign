class ReservationTable < ActiveRecord::Base

	belongs_to :table
	belongs_to :reservation
	
end
