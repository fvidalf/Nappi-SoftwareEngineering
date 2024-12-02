class ReviewsController < ApplicationController
  # CRUD: Create
  def create
    @new_review = Review.new(review_params)
    @new_review.user_id = params[:user_id]
    if params.has_key?(:product_id)
      @new_review.product_id = params[:product_id]
    end
    if @new_review.save
      redirect_to product_path(params[:product_id]), method: :get, notice: "Review creado con éxito"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new_product_review
    if current_user.is_admin == false
      @new_review = Review.new(user_id: params[:user_id], product_id: params[:product_id])
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end

  def review_params
    params.require(:review).permit(:score, :content)
  end

  def destroy
    if current_user.is_admin == true
      @review = Review.find(params[:id])
      @review.destroy
      product_id = @review.product_id
      redirect_to product_path(id: product_id), notice: "Review eliminado con éxito"
    else
      redirect_back_or_to products_path, notice: "No tienes acceso a esta página"
    end
  end 
end
