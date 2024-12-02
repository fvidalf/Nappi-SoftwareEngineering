require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  test "should post chat" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:user)
    
    assert_difference("Chat.count") do
      post create_user_chat_path(user_id: @user.id, admin_id: @admin.id)
    end

    teardown do
      Rails.cache.clear
    end
  end

  test "should get index (admin)" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:user)
    post create_user_chat_path(user_id: @user.id, admin_id: @admin.id)
    sign_out users(:user)

    sign_in users(:admin)
    get index_chats_path(user_id: @admin.id)
    assert_template :index
  
    teardown do
      Rails.cache.clear
    end
  end

  test "should get index (user)" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:user)
    post create_user_chat_path(user_id: @user.id, admin_id: @admin.id)

    get index_chats_path(user_id: @user.id)
    assert_template :index

    teardown do
      Rails.cache.clear
    end
  end
  
  test "should get show" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:user)
    post create_user_chat_path(user_id: @user.id, admin_id: @admin.id)

    get show_chat_path(user_id: @user.id, admin_id: @admin.id)

    assert_template :show

  end
end
