class NotificationsController < ApplicationController
  # CRUD: Read
  def index
    if current_user.id.to_i == params[:user_id].to_i
      @all_notifications = Notification.where(user_id: params[:user_id])
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  # CRUD: Update
  def update_read_status
    notification = Notification.find(params[:id])
    notification.update(read: true)
    redirect_to notifications_path(user_id: params[:user_id])
  end
end
