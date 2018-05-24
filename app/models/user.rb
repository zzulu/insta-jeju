class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :posts
  
  validates :name, presence: true
  
  after_create :default_role
  
  def default_role
    self.add_role(:newuser) if self.roles.blank?
  end
end
