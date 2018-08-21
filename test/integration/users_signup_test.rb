require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup should not create user" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: {
          user: {
              name: " ",
              email: "user@invalid.com",
              password: "foo",
              password_confirmation: "foo",
          }
      }
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select '#error_explanation ul li', "Name can't be blank"
    assert_select '#error_explanation ul li', /Password is too short/
  end

  test "valid signup should create user" do
    assert_difference 'User.count', 1 do
      post signup_path, params: {
          user: {
              name: "BStillman",
              email: "bStillman@valid.com",
              password: "a password",
              password_confirmation: "a password",
          }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
