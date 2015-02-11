class TimeSlot < ActiveRecord::Base
	#scopes
	scope :expire_mode, lambda {|time| where("slot < ?",time)}
	
	#relations
	belongs_to :branch
	#methods
	def self.initialize_slots date,branch_id
		if TimeSlot.where("branch_id = ? AND slot LIKE ? ",branch_id, "%"+date+"%").count == 0
			branch = Branch.find(branch_id)
			Time.zone = "UTC"
			time = branch.open
			while time < branch.close  do
				if Time.zone.parse(date+" "+time.strftime("%H:%M:%S")) > Time.zone.now
					TimeSlot.create(:branch_id =>branch_id,:seats =>0, :slot =>date+" "+time.strftime("%H:%M:%S"))
				end
				time = time + 0.5*60*60
			end
		end
	end
	def self.adjust_people time,count,people
		query = "slot = '"+time.strftime("%Y-%m-%d %H:%M:%S")+"'"
		(1...count).to_a.each do 
			time = time + 0.5*60*60
			query = query + " OR slot = '"+time.strftime("%Y-%m-%d %H:%M:%S")+"'"
		end
		slot = TimeSlot.where(query)
		slot.each do |s|
			s.seats = s.seats + people
			s.save
		end
	end
	def self.get_slots date

	end
	
end
