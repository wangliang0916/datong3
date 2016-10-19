class User < ActiveRecord::Base
  attr_accessible :mobile_phone, :name, :password, :password_confirmation
  has_secure_password

  validates :name, presence: true, length: { maximum: 20 }

  VALID_PHONE_REGEX = /\d{11}/
  validates :mobile_phone, presence: true, 
    format: { with: VALID_PHONE_REGEX }, 
    uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
