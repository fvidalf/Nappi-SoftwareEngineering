require "test_helper"

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Saves message with complete parameters
  test "should save message with complete params" do

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

    # Creates message
    @message = Message.new(content: "Hello")
    @message.user_id = User.all[1].id
    @message.chat_id = Chat.first.id
    result = @message.save
    
    assert result, "did not save message with complete parameters"
  end
  teardown do
    Rails.cache.clear
  end
end
