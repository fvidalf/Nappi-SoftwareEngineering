require "test_helper"

class PRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save PRequest with complete params" do
    setup do
      user = User.new(:user)
      user.save

      admin = User.new(:admin)
      admin.save

      product = Product.new(name: "name", price: 1000, description: "Descripción")
      product.admin_id = User.all[1].id
      product.save
    end

    request = Request.new(date: Time.now, status: "Procesando")
    request.user_id = User.all[0].id
    request.save
    
    p_request = PRequest.new(request_id: Request.first.id, quantity: 1, status: "Creada")
    p_request.product_id = Product.first.id
    result = p_request.save

    assert result, "did not save PRequest with complete params"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save PRequest with no product_id" do
    setup do
      user = User.new(:user)
      user.save

      admin = User.new(:admin)
      admin.save
    end

    request = Request.new(date: Time.now, status: "Procesando")
    request.user_id = User.all[0].id
    request.save
    
    p_request = PRequest.new(request_id: Request.first.id, quantity: 1, status: "Creada")
    result = p_request.save

    assert_not result, "saved a PRequest with no product_id"

    teardown do
      Rails.cache.clear
    end

  end

  test "should not save PRequest with no request_id" do
    setup do
      admin = User.new(:admin)
      admin.save

      product = Product.new(name: "name", price: 1000, description: "Descripción")
      product.admin_id = User.all[1].id
      product.save
    end
    
    p_request = PRequest.new(request_id: nil, quantity: 1, status: "Creada")
    p_request.product_id = Product.first.id
    result = p_request.save

    assert_not result, "saved PRequest with no request_id"

    teardown do
      Rails.cache.clear
    end

  end

  test "should not save PRequest with no quantity" do
    setup do
      user = User.new(:user)
      user.save

      admin = User.new(:admin)
      admin.save

      product = Product.new(name: "name", price: 1000, description: "Descripción")
      product.admin_id = User.all[1].id
      product.save
    end

    request = Request.new(date: Time.now, status: "Procesando")
    request.user_id = User.all[0].id
    request.save
    
    p_request = PRequest.new(request_id: Request.first.id, quantity: nil, status: "Creada")
    p_request.product_id = Product.first.id
    result = p_request.save

    assert_not result, "saved PRequest with no quantity"

    teardown do
      Rails.cache.clear
    end

  end

  test "should not save PRequest with no status" do
    setup do
      user = User.new(:user)
      user.save

      admin = User.new(:admin)
      admin.save

      product = Product.new(name: "name", price: 1000, description: "Descripción")
      product.admin_id = User.all[1].id
      product.save
    end

    request = Request.new(date: Time.now, status: "Procesando")
    request.user_id = User.all[0].id
    request.save
    
    p_request = PRequest.new(request_id: Request.first.id, quantity: 1, status: "")
    p_request.product_id = Product.first.id
    result = p_request.save

    assert_not result, "saved PRequest with no status"

    teardown do
      Rails.cache.clear
    end

  end
end
