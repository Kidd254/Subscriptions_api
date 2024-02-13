class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :packages

validates :email, presence: true
validates :password, presence: true
validates :phone_number, presence: true
  validates :name, presence: true


  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
