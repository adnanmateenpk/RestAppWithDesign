class Reservation < ActiveRecord::Base
	#constants
	DATE_REGEX = /([1]{1}[9]{1}[9]{1}\d{1}|[2-9]{1}\d{3})-([0,1]?\d{1})-([0-2]?\d{1}|[3][0,1]{1})/ 
	#scopes
	scope :sorted, lambda { order("reservations.booking DESC") }
	scope :by_restaurant_owner, lambda { |user| where("reservations.restaurant_owner = ?",user) }
	scope :filter_single_date, lambda { |date| where("STR_TO_DATE(reservations.booking,'%Y-%m-%d') = ? " , date ) }
	scope :filter_between_dates, lambda { |from,to| where("STR_TO_DATE(reservations.booking,'%Y-%m-%d') BETWEEN ? AND ?" , from,to ) }
	scope :search_name_code , lambda { |data| where("reservations.reservation_name LIKE ? OR reservation_code LIKE ?" , "%"+data+"%" ,"%"+data+"%"  ) }
	scope :expire_mode, lambda {|time| where("reservations.status = 1 AND reservations.expire_at < ?",time)}
	scope :availability_for_restaurant , lambda {|date,branch,id| where("reservations.status = ? AND reservations.branch_id = ? AND reservations.booking<= ? AND reservations.expire_at > ? AND reservations.id != ?",true,branch,date,date,id)}
	#validations
	validates :reservation_name, :presence => true, :length => {:maximum => 25}
	validates :reservation_code, :presence => true, :length => {:maximum => 6}, :uniqueness => true
	validates :branch_id, :presence => true,:numericality => { :only_integer => true , :greater_than => 0 }
	
	#relations
	
	belongs_to :branch
	
	belongs_to :user , :primary_key => :membership
	belongs_to :creator , :foreign_key => :created_by , :class_name => "User"
	has_many :reservation_tables , dependent: :destroy
	def self.expire_reservations
		Time.zone = "UTC"
		reservations = Reservation.expire_mode(Time.zone.now.strftime("%Y-%m-%d %H:%M"))
		reservations.each do |r|
			r.status = 0
			AdminMailer.cancel_reservation(r.user,r.reservation_code).deliver_now
			r.save
		end
		reservations
	end
end

