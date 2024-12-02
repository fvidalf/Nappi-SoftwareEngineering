class PRequestsController < ApplicationController
  # CRUD: Read
  def admin_index
    if current_user.id.to_i == params[:user_id].to_i
      @p_requests = PRequest.where(product_id: User.find(params[:user_id]).product_ids)
      @user_names = []
      @product_names = []
      @requests = []
      @p_requests.each do |p_request|
        product_name = Product.find(p_request.product_id).name
        request = Request.find(p_request.request_id)
        @requests.append(request)
        @product_names.append(product_name)
      end
      @requests.each do |request|
        user_name = User.find(request.user_id).name
        @user_names.append(user_name)
      end
    else
      redirect_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  # CRUD: Update
  def update
    @p_request = PRequest.where(product_id: params[:product_id], request_id: params[:request_id]).first
    if params[:operation] == 'add'
      @p_request.update(quantity: @p_request.quantity + 1)
    elsif params[:operation] == 'subst'
      @p_request.update(quantity: @p_request.quantity - 1)
    elsif params[:operation] == 'delete'
      @p_request.update(quantity: 0)
    end
    if @p_request.quantity == 0
      @p_request.destroy
    end
    if PRequest.where(request_id: params[:request_id]).empty?
      redirect_to destroy_cart_request_path(params[:user_id], params[:request_id]), method: :get and return
    end
    redirect_to user_cart_path(params[:user_id])
  end

  def update_status
    @p_requests = PRequest.where(request_id: params[:request_id])
    @p_requests.each do |p_request|
      p_request.update(status: "Esperando Aprobación")
      notify_admin = Notification.new(sender_user_id: current_user.id, read: false)
      notify_admin.user_id = p_request.product.admin_id
      notify_admin.content = current_user.name + ' ha solicitado aprobación del producto ' + p_request.product.name
      notify_admin.save
    end
    redirect_to send_request_path(user_id: params[:user_id], request_id: params[:request_id])
  end
  
  def admin_update
    @p_request = PRequest.find(params[:p_request_id])
    notify_user = Notification.new(sender_user_id: current_user.id, read: false)
    notify_user.user_id = @p_request.request.user_id
    if params[:resolution] == 'aproved'
      @p_request.update(status: "Aprobada")
      resolution = ' ha aprobado la solicitud del producto '
    elsif params[:resolution] == 'declined'
      @p_request.update(status: "Rechazada")
      resolution = ' ha rechazado la solicitud del producto '
    end
    notify_user.content = current_user.name + resolution + @p_request.product.name
    notify_user.save
    redirect_to admin_p_requests_path(params[:user_id])
  end
end
