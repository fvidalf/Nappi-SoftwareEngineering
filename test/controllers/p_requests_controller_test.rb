require "test_helper"

class PRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  test "should get admin index" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:admin)
    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin.id
         }
    sign_out @admin

    sign_in users(:user)
    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}
    sign_out @user

    p_request = PRequest.new(request_id: Request.last.id, quantity: 1, status: "Creada")
    p_request.product_id = Product.last.id
    p_request.save

    sign_in users(:admin)
    get admin_p_requests_path(user_id: @admin.id)
    assert_template :admin_index

    teardown do
      Rails.cache.clear
    end
  end

  test "should update status" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:admin)
    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin.id
         }
    sign_out @admin

    sign_in users(:user)
    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}

    p_request = PRequest.new(request_id: Request.last.id, quantity: 1, status: "Creada")
    p_request.product_id = Product.last.id
    p_request.save

    patch send_p_requests_path(user_id: @user.id, request_id: Request.last.id)
    assert_redirected_to send_request_path(user_id: @user.id, request_id: Request.last.id)

    teardown do
      Rails.cache.clear
    end
  end

  test "should update with add operation" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:admin)
    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin.id
         }
    sign_out @admin

    sign_in users(:user)
    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}

    p_request = PRequest.new(request_id: Request.last.id, quantity: 1, status: "Creada")
    p_request.product_id = Product.last.id
    p_request.save
    
    assert_difference('PRequest.last.quantity') do
      patch update_p_request_path(product_id: Product.last.id, request_id: Request.last.id, operation: "add")
    end
    assert_redirected_to user_cart_path(user_id: @user.id)

    teardown do
      Rails.cache.clear
    end
  end

  test "should update with subst operation" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    sign_in users(:admin)
    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin.id
         }
    sign_out @admin

    sign_in users(:user)
    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}

    p_request = PRequest.new(request_id: Request.last.id, quantity: 2, status: "Creada")
    p_request.product_id = Product.last.id
    p_request.save
    
    assert_difference('PRequest.last.quantity', -1) do
      patch update_p_request_path(product_id: Product.last.id, request_id: Request.last.id, operation: "subst")
    end
    assert_difference('PRequest.count', -1) do
      patch update_p_request_path(product_id: Product.last.id, request_id: Request.last.id, operation: "subst")
    end
    #assert_redirected_to user_cart_path(user_id: @user.id)

    teardown do
      Rails.cache.clear
    end
  end
end
