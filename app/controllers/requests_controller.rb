class RequestsController < ApplicationController
  before_action :authenticate_user!
  # CRUD: Read
  def index
    if current_user.is_admin == false
      @all_requests = User.find(params[:user_id]).requests.all
      @all_requests.each do |request|
        finalizada = true
        request.p_requests.each do |p_request|
          if not ["Aprobada", "Rechazada"].include?(p_request.status)
            finalizada = false
          end
        end
        if finalizada
          request.status = 'Finalizada'
        end
      end
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  def show
    if current_user.is_admin == false
      @request = Request.find(params[:id])
      @total_cost = 0
      @quantites = []
      @products_status = []
      @request.products.all.each do |product|
        cantidad_producto = PRequest.where(request_id: @request.id, product_id: product.id).first.quantity
        status_producto = PRequest.where(request_id: @request.id, product_id: product.id).first.status
        @quantites.append(cantidad_producto)
        @products_status.append(status_producto)
        @total_cost += cantidad_producto * product.price
      end
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  def show_cart
    if current_user.is_admin == false
      @empty_request = false
      @requests = User.find(params[:user_id]).requests.where(status: "Procesando")
      if @requests.empty?
        @empty_request = true
      else
        @request = @requests.first
        @total_cost = 0
        @quantites = []
        @request.products.all.each do |product|
          cantidad_producto = PRequest.where(request_id: @request.id, product_id: product.id).first.quantity
          @quantites.append(cantidad_producto)
          @total_cost += cantidad_producto * product.price
        end
      end
    else 
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  # CRUD: Create
  def create
    if current_user.is_admin == false
      @requests_activas = User.find(params[:user_id]).requests.where(status: "Procesando")
      if @requests_activas.empty?
        # Si no existe una request activa se crea una nueva y se asigna el request_id a la nueva
        # p_request
        @new_request = Request.new(date: Time.now, status: "Procesando")
        @new_request.user_id = params[:user_id]
        @new_request.save
        @p_requests_activas = PRequest.where(request_id: @new_request.id, product_id: params[:product_id])
        if @p_requests_activas.empty?
          # Si no existe una p_request asociada a la request y al producto pedido se
          # instancia una p_request con cantidad 1 del producto asociandola a la request
          @new_p_request = PRequest.new(request_id: @new_request.id, quantity: 1, status: "Creada")
          @new_p_request.product_id = params[:product_id]
          @new_p_request.save
        else
          # Caso contrario, se aumenta en 1 la cantidad de este producto en la p_request existente
          @p_request = @p_requests_activas.first
          @p_request.update(quantity: @p_request.quantity + 1)
        end
      else
        # Si existe una request activa se asigna el request_id respectivo a una nueva p_request
        @p_requests_activas = PRequest.where(request_id: @requests_activas.first.id, product_id: params[:product_id])
        if @p_requests_activas.empty?
          # Si no existe una p_request asociada a la request y al producto pedido se
          # instancia una p_request con cantidad 1 del producto asociandola a la request
          @new_p_request = PRequest.new(request_id: @requests_activas.first.id, quantity: 1, status: "Creada")
          @new_p_request.product_id = params[:product_id]
          @new_p_request.save
        else
          # Caso contrario, se aumenta en 1 la cantidad de este producto en la p_request existente
          @p_request = @p_requests_activas.first
          @p_request.update(quantity: @p_request.quantity + 1)
        end
      end
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  # CRUD: Update
  def update_status
    @request = Request.find(params[:request_id])
    @request.update(status: "Enviada")
    redirect_to user_cart_path(params[:user_id])
  end

  # CRUD: Delete
  def destroy_from_cart
    @request = Request.find(params[:request_id])
    @request.destroy
    redirect_to user_cart_path(params[:user_id])
  end
  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to user_requests_path(current_user.id)
  end
end
