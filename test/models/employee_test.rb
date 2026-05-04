require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def setup
    @employee = Employee.new(
      first_name: "John",
      last_name: "Doe",
      job_title: "Engineer",
      department: 'IT',
      country: "USA",
      salary: 80000.00,
      currency: 'INR',
      hire_date: Date.today
    )
  end

  test "should be valid with all required attributes" do
    assert @employee.valid?
  end

  test "should invalidate negative salary" do
    @employee.salary = -5000
    assert_not @employee.valid?
    assert_includes @employee.errors[:salary], "must be greater than or equal to 0"
  end

  test "should require first name and last name" do
    @employee.first_name = ""
    @employee.last_name = nil
    assert_not @employee.valid?
  end

  test "should accept zero salary" do
    @employee.salary = 0
    assert @employee.valid?, "Employee should be valid with a zero salary (e.g., unpaid intern)"
  end  
end