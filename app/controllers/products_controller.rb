class ProductsController < ApplicationController

  before_action :authenticate_user!
  # CRUD: Create
  def new
    if current_user.is_admin == true 
      @new_product = Product.new
    else
      redirect_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  def create
    @new_product = Product.new(product_params)
    @new_product.admin_id = params[:admin_id]
    if @new_product.save
      logger.info "redirect"
      redirect_to products_path, notice: "Producto creado con éxito"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :image)
  end

  # CRUD: Read
  def index
    if current_user.is_admin == false
      @all_products = Product.all
    # Para admin, agregar products cuyo product_id sea igual a current_user.id
    else
      @all_products = []
      Product.all.each do |product|
        if product.admin_id.to_i == current_user.id.to_i
          @all_products.push(product)
        end
      end
    end
  end
  
  def show
    @product = Product.find(params[:id])

    # Reviews
    @product_reviews = Review.where(product_id: params[:id])
  end

  # CRUD: Update
  def edit
    if (not Product.find(params[:id]).nil?) && current_user.is_admin == true &&
      Product.find(params[:id]).admin_id.to_i == current_user.id.to_i
      @product = Product.find(params[:id])
    else
      redirect_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "Producto actualizado con éxito."
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  # CRUD: Delete
  def destroy
    if current_user.is_admin == true 
      @product = Product.find(params[:id])
      @product.destroy
      redirect_to products_path, notice: "Producto eliminado con éxito"
    else
      redirect_to products_path, notice: "No tienes acceso a esta página"
    end
  end
end
