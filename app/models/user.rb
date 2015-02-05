class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #relations
  belongs_to :role
  has_many :restaurants , dependent: :destroy

  #validations
  validates :name,		:presence => true,
							:length => { :maximum => 25 }
end
