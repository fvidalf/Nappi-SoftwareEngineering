require "test_helper"

class ChatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should save chat with complete params" do
    setup do
      # creates admin
      admin = User.new(:admin)
      admin.save

      # creates user 
      user = User.new(:user)
      user.save
    end
    # creates chat
    chat = Chat.new()
    chat.user_id = User.all[1].id
    chat.admin_id = User.all[0].id
    result = chat.save

    assert result, "did not save chat with complete params"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save chat with no user" do
    setup do
      # creates admin
      admin = User.new(:admin)
      admin.save

    end
    # creates chat
    chat = Chat.new()
    chat.admin_id = User.all[0].id
    result = chat.save

    assert_not result, "saved chat with no user"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save chat with no admin" do
    setup do
      # creates user
      user = User.new(:user)
      user.save

    end
    # creates chat
    chat = Chat.new()
    chat.user_id = User.all[0].id
    result = chat.save

    assert_not result, "saved chat with no admin"

    teardown do
      Rails.cache.clear
    end
  end

  test "deletes messages when destroyed" do
    setup do
      # creates admin
      admin = User.new(:admin)
      admin.save

      # creates user 
      user = User.new(:user)
      user.save
    end
    # creates chat
    chat = Chat.new()
    chat.user_id = User.all[1].id
    chat.admin_id = User.all[0].id
    chat.save

    message = Message.new(content: "Hello")
    message.user_id = User.all[1].id
    message.chat_id = Chat.first.id
    message.save

    assert_difference('Message.count', -1) do
      chat.destroy
    end
    
    teardown do
      Rails.cache.clear
    end
  end
end
