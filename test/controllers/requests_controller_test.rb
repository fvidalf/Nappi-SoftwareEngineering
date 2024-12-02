require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    get user_requests_path(user_id: @user.id)

    assert_template :index
    teardown do
      Rails.cache.clear
    end
  end

  test "should post" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin.id
         }

    assert_difference('Request.count') do
      post user_requests_path(user_id: @admin.id),
           params: {id: Product.last.id}
    end

    teardown do
      Rails.cache.clear
    end
  end

  test "should delete" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin.id
         }

    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}

    assert_difference('Request.count', -1) do
      delete user_request_path(user_id: @admin.id, id: Request.last.id)
    end
    assert_redirected_to user_requests_path(@user.id)

    teardown do
      Rails.cache.clear
    end

  end
  
  test "should update" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin.id
         }

    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}

    get send_request_path(user_id: @user.id),
        params: {request_id: Request.last.id}

    assert_redirected_to user_cart_path(@user.id)

    teardown do
      Rails.cache.clear
    end
  end

  test "should get show" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin_id
         }

    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}

    p_request = PRequest.new(request_id: Request.last.id, quantity: 1, status: "Creada")
    p_request.product_id = Product.last.id
    p_request.save

    get user_request_path(id: Request.last.id)
    assert_template :show
  end

  test "should get cart" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    post products_path, 
         params: { 
           product: { 
             name: "Name",
             price: 1000,
             description: "Descripción",
           },
           admin_id: @admin_id
         }

    post user_requests_path(user_id: @user.id),
         params: {id: Product.last.id}

    p_request = PRequest.new(request_id: Request.last.id, quantity: 1, status: "Creada")
    p_request.product_id = Product.last.id
    p_request.save

    get user_cart_path(user_id: @user.id)
    assert_template :show_cart 
  end
end
