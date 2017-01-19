require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new( name: "Satan",
                      email: "darklord@hell.gov",
                      password: "damnation",
                      password_confirmation: "damnation")
  end # setup end

  test "should be valid" do
    assert @user.valid?
  end #should be valid

  test "name should be present" do
    @user.name = "       "
    assert_not @user.valid?
  end #name should be present

  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end #email should be present

  test "name should not be too long" do
    @user.name = "Adolph Blaine Charles David Earl Frederick Gerald Hubert Irvin John Kenneth Lloyd Martin Nero Oliver Paul Quincy Randolph Sherman Thomas Uncas Victor William Xerxes Yancy Wolfeschlegelsteinhausenbergerdorff"
    assert_not @user.valid?
  end #name should not be too long

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end #email should not be too long

  test "email validation should accept valid addresses" do
    valid_addresses = [
                      "user@example.com",
                      "USER@foo.com",
                      "Au_E-r@example.foo.bar",
                      "first.last@foo.jp",
                      "buddy+pappy@gibblys.ribb"]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid."
    end #valid_address
  end #email validation should accept valid addresses

  test "email validation should reject invalid addresses" do
    invalid_addresses = [
                      "user@example,com",
                      "USER_at_foo.com",
                      "user.name@example.",
                      "foo@bar_baz.com",
                      "foo@bar..com",
                      "buddypappy@gibblys+ribb"]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid."
    end #invalid_address
  end #email validation should reject invalid addresses

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end #email addresses should be unique

  test "email addresses should be saved as lowercase" do
    mixed_case_email = "DiPper@GraVItY.FalLS"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end #email addresses should be saved as lowercase

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end #password should be present (nonblank)

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end #password should have a minimum length

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end #authenticated? should return false for a user with nil digest
end
