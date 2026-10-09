require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "validates presence of name and email" do
    user = User.new
    assert_not user.valid?
    assert user.errors[:name].any?
    assert user.errors[:email].any?
  end

  test "validates uniqueness of email" do
    User.create!(name: "Juan", email: "unico@example.com", password: "password123")
    duplicate = User.new(name: "Otro", email: "unico@example.com", password: "password123")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "ya está en uso"
  end

  test "generates api_token on creation" do
    user = User.create!(name: "Token User", email: "token_user@example.com", password: "password123")
    assert_not_nil user.api_token
    assert_equal 48, user.api_token.length
  end

  test "regenerates and invalidates api_token" do
    user = User.create!(name: "Token User 2", email: "token_user2@example.com", password: "password123")
    old_token = user.api_token

    user.regenerate_api_token!
    assert_not_equal old_token, user.api_token

    user.invalidate_api_token!
    assert_nil user.api_token
  end

  test "roles are customer and seller" do
    user = User.new(name: "Cliente", email: "c@example.com", password: "password123", role: :customer)
    assert user.customer?
    assert_not user.seller?

    seller = User.new(name: "Vendedor", email: "v@example.com", password: "password123", role: :seller)
    assert seller.seller?
  end
end
