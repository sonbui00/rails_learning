require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new name: "Example User", email: "user@example.com",
            password: "foobar", password_confirmation: "foobar"
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid adresses" do
    invalid_addresses = %w[
      user@example,com
      USER_foo.COM
      A_US-ER@foo.bar.org.
      first.last@foo_jp
      alice+bob@bar+baz.cn
    ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid"
    end
  end

  test "email should be unique" do
    @duplicate_user = @user.dup
    @user.save
    assert_not @duplicate_user.valid?

    @duplicate_user.email = @user.email.upcase
    assert_not @duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minium length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false if remember_digest nil" do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum!')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow user" do
    sonbv = users(:sonbv)
    user_28 = users(:user_28)
    assert_not sonbv.following?(user_28)
    assert_not user_28.followers.include?(sonbv)
    sonbv.follow(user_28)
    assert sonbv.following?(user_28)
    assert user_28.followers.include?(sonbv)
    sonbv.unfollow(user_28)
    assert_not sonbv.following?(user_28)
    assert_not user_28.followers.include?(sonbv)
  end

  test "feed should have the right posts" do
    sonbv = users(:sonbv)
    hacker = users(:hacker)
    other = users(:user_1)
    # Posts from followed  user
    assert sonbv.following?(hacker)
    assert hacker.microposts.count > 0
    hacker.microposts.each do |post_following|
      assert sonbv.feed.include?(post_following)
    end
    # Posts from self
    assert sonbv.microposts.count > 0
    sonbv.microposts.each do |post_following|
      assert sonbv.feed.include?(post_following)
    end
    # Posts from unfollowed user
    assert_not sonbv.following?(other)
    assert other.microposts.count > 0
    other.microposts.each do |post_following|
      assert_not sonbv.feed.include?(post_following)
    end
  end

end
