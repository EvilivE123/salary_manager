class User < ApplicationRecord
  has_secure_password
  
  enum :role, { admin: 0, hr_manager: 1 }

  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
end