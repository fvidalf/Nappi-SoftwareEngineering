class MessagesController < ApplicationController
  before_action :authenticate_user!

  # CRUD: Create
  def create
    @message = Message.new(content: params[:message][:content])
    @message.user = current_user
    @message.chat_id = params[:chat_id]
    if @message.save
    else
      render usuario_chat_path
    end
  end

end
