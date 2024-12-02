require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "should save user with complete params" do
    user = User.new(
      email: "test2@example.com",
      encrypted_password: "<%= User.new.send(:password_digest, '123greetings')",
      is_admin: 0,
      name: "user"
    )
    user.save 
    assert user, "did not save user with complete params"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save user with no is_admin" do
    user = User.new(
      email: "test2@example.com",
      encrypted_password: "<%= User.new.send(:password_digest, '123greetings')",
      is_admin: nil,
      name: "user"
    )
    result = user.save 
    assert_not result, "saved user with no is_admin"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save user with no name" do
    user = User.new(
      email: "test2@example.com",
      encrypted_password: "<%= User.new.send(:password_digest, '123greetings')",
      is_admin: 0,
      name: ""
    )
    result = user.save 
    assert_not result, "saved user with no name"

    teardown do
      Rails.cache.clear
    end
  end
end
