require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "invalid login should display error messages" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'

    assert flash.present?
    get root_path
    assert flash.empty?
  end

  test "valid login followed by logout" do
    get login_path
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    assert_redirected_to user_path(@user)
    follow_redirect!

    assert is_logged_in?
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    # Log Out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # Simulate a user logging out in a second window
    delete logout_path
    follow_redirect!

    assert_not is_logged_in?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    puts @user.remember_token
    assert_not_empty cookies[:remember_token]
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    # Login again to confirm that cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

end
