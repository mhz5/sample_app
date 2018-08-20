require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "_" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "_" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = [
        "user@example.com",
        "USER@foo.COM",
        "A_US-ER@foo.bar.org",
        "first.last@aoei.snth",
        "alice+bob@baz.cn",
    ]

    valid_addresses.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid."
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = [
        "emailaddress",
        "user@example",
        "user@",
        "user name@example.com",
        "@example",
        "@example.com",
        "foo@bar_baz.com",
        "foo@bar+baz.com",
        "foo@baz..com",
    ]

    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should NOT be valid."
    end

  end

  test "email addresses should be unique" do
    dup_user1 = User.new
    dup_user1.email = @user.email
    dup_user2 = User.new
    dup_user2.email = @user.email.upcase

    assert_not dup_user1.valid?
    assert_not dup_user2.valid?
  end

  test "email addresses should be saved as lower case" do
    email = "FOO.BAR@example.COM"
    @user.email = email
    @user.save
    assert_equal email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
