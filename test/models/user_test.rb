require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test.user@example.com",
      password: "securepassword123",
      password_confirmation: "securepassword123",
      first_name: "Jane",
      last_name: "Doe"
    )
  end

  # --- Happy Path ---
  test "should be valid with all required attributes" do
    assert @user.valid?
  end

  # --- Email Validations ---
  test "should require an email" do
    @user.email = " "
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "should require a unique email" do
    @user.save!
    duplicate_user = @user.dup
    # Tests uniqueness case-insensitivity if your DB/Rails is configured for it
    duplicate_user.email = @user.email.upcase 
    
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "should accept valid email formats" do
    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "should reject invalid email formats" do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
      assert_includes @user.errors[:email], "is invalid"
    end
  end

  # --- Name Validations ---
  test "should require a first_name" do
    @user.first_name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:first_name], "can't be blank"
  end

  test "should require a last_name" do
    @user.last_name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:last_name], "can't be blank"
  end

  # --- Password (has_secure_password) ---
  test "should require a password on creation" do
    @user.password = nil
    @user.password_confirmation = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "password and password_confirmation must match" do
    @user.password_confirmation = "mismatchingpassword"
    assert_not @user.valid?
    assert_includes @user.errors[:password_confirmation], "doesn't match Password"
  end

  # --- Role Enum & Defaults ---
  test "should have hr_manager as the default role" do
    # Initializes a new user without passing a role to test the schema's default: 1
    new_user = User.new
    assert_equal "hr_manager", new_user.role
    assert new_user.hr_manager?
  end

  test "should allow setting role to admin" do
    @user.role = :admin
    assert @user.admin?
    assert_equal "admin", @user.role
  end
end