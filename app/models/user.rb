class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {user: "user", admin: "admin"}

  validates :email, uniqueness: true

  scope :users, -> { where(role: "user") }
end
