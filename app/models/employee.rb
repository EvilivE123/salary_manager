class Employee < ApplicationRecord
  enum :status, { active: 0, terminated: 1, on_leave: 2 }
  
  validates :first_name, :last_name, :job_title, :department, :country, :currency, :hire_date, presence: true
  validates :salary, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_999_999.99 }
end