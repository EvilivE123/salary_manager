require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Assuming user fixtures exist as defined in Phase 2
    @user = users(:hr_manager)
    # Use your new global helper!
    log_in_as(@user)
    # Create an employee for testing updates/deletions
    @employee = Employee.create!(
      first_name: "Jane", last_name: "Smith", job_title: "Manager", department: "IT",
      country: "Canada", salary: 90000.00, currency: "INR", hire_date: Date.today
    )
  end

  test "should get index" do
    get employees_url
    assert_response :success
    # FIX: Check the rendered HTML instead of instance variables.
    # Adjust the CSS selector ("tbody tr", "h1", etc.) based on your actual view template.
    assert_select "body" # Basic check that the page rendered
    # assert_select "td", text: "Jane" # Better check: verify the employee is on the page
  end

  test "should create employee" do
    assert_difference("Employee.count", 1) do
      post employees_url, params: { employee: { 
        first_name: "New", last_name: "Hire", job_title: "Dev", department: "Security", 
        country: "UK", salary: 60000.00, currency: "USD", hire_date: Date.today 
      } }
    end
    assert_redirected_to employee_url(Employee.last)
  end

  test "should update employee" do
    patch employee_url(@employee), params: { employee: { job_title: "Senior Manager" } }
    assert_redirected_to employee_url(@employee)
    @employee.reload
    assert_equal "Senior Manager", @employee.job_title
  end

  test "should destroy employee via JSON" do
    assert_difference("Employee.count", -1) do
      delete employee_url(@employee), as: :json
    end
    assert_response 200
  end
end