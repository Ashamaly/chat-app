class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  has_many :room

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :username, uniqueness: true, presence: true

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
