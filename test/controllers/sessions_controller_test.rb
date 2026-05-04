require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new login form" do
    get login_path
    assert_response :success
  end

  test "should login valid user" do
    post login_path, params: { email: users(:hr_manager).email, password: 'password123' }
    assert_redirected_to root_path
    assert_equal users(:hr_manager).id, session[:user_id]
  end

  test "should reject invalid user password" do
    post login_path, params: { email: users(:hr_manager).email, password: 'wrong_password' }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should successfully logout user" do
    post login_path, params: { email: users(:hr_manager).email, password: 'password123' }
    delete logout_path
    assert_redirected_to login_path
    assert_nil session[:user_id]
  end
end
