require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:dave)
  end

  test 'password resets' do
    get forgot_path
    assert_template 'password_resets/new'
    # Invalid email
    post forgot_path, password_reset: { email: '' }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post forgot_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # Right email, wrong token
    get reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Invalid password & confirmation
    patch reset_path(user.reset_token),
          email: user.email,
          user: { password: 'foobaz', password_confirmation: 'barquux' }
    assert_select 'div#error_explanation'
    # Empty password
    patch reset_path(user.reset_token),
          email: user.email,
          user: { password: '', password_confirmation: '' }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch reset_path(user.reset_token),
          email: user.email,
          user: { password: 'foobaz', password_confirmation: 'foobaz' }
    assert logged_in_here?
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
