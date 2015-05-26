class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #relations
  belongs_to :role
  has_many :restaurants , dependent: :destroy
  has_many :reservations , dependent: :destroy , :primary_key => :membership
  has_many :creations, dependent: :destroy, :foreign_key => :created_by , :class_name => "Reservation"
  has_many :restaurant_customer
  has_many :restaurants_ids , :through => :restaurant_customer , :source => :restaurant_owner
  has_many :customer_ids, :foreign_key => :restaurant_owner_id , :class_name => "RestaurantCustomer"
  has_many :customers , :through => :customer_ids , :source => :user
  #scopes
  scope :without_current , lambda {|id| where("users.id != ?",id) }
  scope :search, lambda { |data| where("users.membership LIKE ? OR users.name LIKE ?" , "%"+data+"%", "%"+data+"%" ) }
  scope :limited_users, lambda { where("users.role_id = ? OR users.role_id = ? ",2,3) }
  
  #validations
  validates :name,		:presence => true,
							:length => { :maximum => 25 }
  validates :phone,    :presence => true  , :format => {:with => /^[0-9]*$/ , :message => "Not a Valid Number"}
  validates :membership,:uniqueness => true, 
                        :length => { :maximum => 6 },
                        :presence => true
end
