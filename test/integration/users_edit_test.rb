require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users (:taylor)
    @other_user = users (:vader)
  end

  test "unsuccesful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "successful edit" do
    # simulates a log-in as a valid user
    log_in_as(@user)
    # navigate to the edit user page
    get edit_user_path(@user)
    # assures the page we get is the edit page
    assert_template 'users/edit'
    # local variables for later
    name = "Foo Bar"
    email = "foo@bar.com"

    # simulates changes to user name and email (patches in changes)
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    # ensures the flash message is displaying
    assert_not flash.empty?
    # checks that we are redirected to the user page after we finish editing.
    assert_redirected_to @user
    # reloads the user to double check that our changes were saved.
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    # navigate to the edit user page
    get edit_user_path(@user)
    # simulates a log-in as a valid user
    log_in_as(@user)
    # assures the page we redirect to is the edit page
    assert_redirected_to edit_user_url(@user)
    # local variables for later
    name = "Foo Bar"
    email = "foo@bar.com"

    # simulates changes to user name and email (patches in changes)
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    # ensures the flash message is displaying
    assert_not flash.empty?
    # checks that we are redirected to the user page after we finish editing.
    assert_redirected_to @user
    # reloads the user to double check that our changes were saved.
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  # ----------------------------------------------------------

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }

    assert_not flash.empty?
    assert_redirected_to login_url
  end

# ----------------------------------------------------------

  test "should redirect edit when not logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }

    assert flash.empty?
    assert_redirected_to root_url
  end
end
