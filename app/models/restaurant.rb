class Restaurant < ActiveRecord::Base
	
	#relations
	has_many :branches , dependent: :destroy
	has_many :tables , dependent: :destroy
	has_many :date_restrictions , dependent: :destroy
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
	# This method associates the attribute ":avatar" with a file attachment
	  has_attached_file :logo, styles: {
	    thumb: '100x100>',
	    square: '200x200#',
	    medium: '300x300>'
	  }

	  # Validate the attached image is image/jpg, image/png, etc
	  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
		before_save :destroy_logo?

		  def logo_delete
		    @logo_delete ||= "0"
		  end

		  def logo_delete=(value)
		    @logo_delete = value
		  end

		private
		  def destroy_image?
		    self.logo.clear if @logo_delete == "1"
		  end
end
