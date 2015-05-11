class Table < ActiveRecord::Base

	belongs_to :restaurant
	has_many :reservation_tables , dependent: :destroy
	scope :largest_capacity, lambda { order("tables.seats DESC") }
	scope :reservation_tables_check, lambda {|min,max,r| where("tables.seats >= ? AND tables.seats <= ? AND restaurant_id = ?" , min,max,r)}

	validates :seats, 		:presence => true,:numericality => { :only_integer => true , :greater_than => 0 }
	validates :quantity, 		:presence => true,:numericality => { :only_integer => true , :greater_than => 0 }
	validates :restaurant_id, 		:presence => true,:numericality => { :only_integer => true , :greater_than => 0 }
end
