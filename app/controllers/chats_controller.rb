class ChatsController < ApplicationController
  # CRUD: Create
  def create
    if current_user.is_admin == false
      unless Chat.where(admin_id: params[:admin_id], user_id: params[:user_id]).empty?
        redirect_to show_chat_path(user_id: params[:user_id], admin_id: params[:admin_id]), method: :get
      else
        @new_chat = Chat.new(user_id: params[:user_id], admin_id: params[:admin_id])
        if @new_chat.save
          redirect_to show_chat_path(user_id: params[:user_id], admin_id: params[:admin_id]), method: :get
        else
          render :new, status: :unprocessable_entity
        end
      end
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  # CRUD: Read
  def index
    if current_user.id.to_i == params[:user_id].to_i
      if User.find(params[:user_id]).is_admin
        @names = []
        @ids = []
        @all_chats = Chat.where(admin_id: params[:user_id])
        @all_chats.each do |chat|
          user_name = User.find(chat.user_id).name
          @names.append(user_name)
          @ids.append(chat.user_id)
        end
      else
        @names = []
        @ids = []
        @all_chats = Chat.where(user_id: params[:user_id])
        @all_chats.each do |chat|
          shop_name = User.find(chat.admin_id).name
          @names.append(shop_name)
          @ids.append(chat.admin_id)
        end
      end
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  def show
    if [params[:admin_id].to_i, params[:user_id].to_i].include?(current_user.id.to_i)
      unless Chat.where(admin_id: params[:admin_id], user_id: params[:user_id]).empty?
        @chat = Chat.where(user_id: params[:user_id], admin_id: params[:admin_id]).first
        @messages = @chat.messages
        # Definir más variables que se necesiten
      else
        redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
      end
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  # CRUD: Delete
  def destroy
    if current_user.is_admin == true
      @chat = Chat.find(params[:chat_id])
      @chat.destroy
      redirect_to index_chats_path(params[:user_id]), method: :get
    end
  end
end
