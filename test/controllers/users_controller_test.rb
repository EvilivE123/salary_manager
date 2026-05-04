require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @hr_manager = users(:hr_manager)
    @user_to_edit = users(:hr_manager)
  end

  test "should redirect non-admin users from users index" do
    # Login as standard HR Manager
    log_in_as(@hr_manager)
    get users_url
    assert_redirected_to root_path
    assert_equal "Unauthorized access.", flash[:alert]
  end

  test "should allow admin to access users index" do
    # Login as Admin
    log_in_as(@admin)
    
    get users_url
    assert_response :success
    assert_select "body" # Basic check that the page rendered
  end

  test "admin can create a new HR manager" do
    log_in_as(@admin)

    assert_difference("User.count", 1) do
      post users_url, params: { user: { 
        first_name: "New", 
        last_name: "HR", 
        email: "newhr@example.com", 
        password: "password123", 
        password_confirmation: "password123" 
      } }
    end
    assert_redirected_to user_url(User.last)
    assert_equal "hr_manager", User.last.role
  end
end