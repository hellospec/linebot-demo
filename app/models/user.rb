class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {user: "user", admin: "admin", api: "api"}

  has_many :sales

  validates :email, uniqueness: true

  scope :users, -> { where.not(role: "admin") }

  def self.authenticate(email, password)
    user = User.find_for_authentication(:email => email)
    user&.valid_password?(password) ? user : nil
  end
end
