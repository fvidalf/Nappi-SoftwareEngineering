require "test_helper"

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should save request with complete params" do
    setup do
      user = User.new(:user)
      user.save
    end

    request = Request.new(date: Time.now, status: "Procesando")
    request.user_id = User.first.id
    result = request.save

    assert result, "did not save request with complete params"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save request with no user_id" do
    request = Request.new(date: Time.now, status: "Procesando")
    result = request.save

    assert_not result, "saved a request with no user_id"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save request with no date" do
    setup do
      user = User.new(:user)
      user.save
    end

    request = Request.new(date: nil, status: "Procesando")
    request.user_id = User.first.id
    result = request.save

    assert_not result, "saved a request with no date"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save request with no status" do
    setup do
      user = User.new(:user)
      user.save
    end

    request = Request.new(date: Time.now, status: "")
    request.user_id = User.first.id
    result = request.save

    assert_not result, "saved a request with no status"

    teardown do
      Rails.cache.clear
    end
  end

  test "destroy should delete dependant PRequests" do
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
    p_request.save

    assert_difference('PRequest.count', -1) do
      request.destroy
    end

    teardown do
      Rails.cache.clear
    end
  end
end
