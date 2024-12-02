require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  test "should post message" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    # creates chat
    chat = Chat.new()
    chat.user_id = @user.id
    chat.admin_id = @admin.id
    chat.save

    sign_in users(:user)

    assert_difference("Message.count") do
      post chat_messages_path(chat_id: Chat.last.id),
           params: {
             message: {
               content: "Hola"
             }
           }
    end

    teardown do
      Rails.cache.clear
    end
  end
end
