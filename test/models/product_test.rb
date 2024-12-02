require "test_helper"

class ProductTest < ActiveSupport::TestCase

  test "should not save product without name" do
    setup do
      admin = User.new(:admin)
      admin.save 
    end

    @product = Product.new(name: "", price: 1000, description: "Descripción")
    @product.admin_id = User.first.id
    result = @product.save

    assert_not result, "saved a product with no name"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save product without price" do
    setup do
      admin = User.new(:admin)
      admin.save
    end

    @product = Product.new(name: "name", price: nil, description: "Descripción")
    @product.admin_id = User.first.id
    result = @product.save

    assert_not result, "saved a product with no name"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save product with no admin_id" do

    @product = Product.new(name: "name", price: 1000, description: "Descripción")
    result = @product.save

    assert_not result, "saved a product with no admin_id"

    teardown do
      Rails.cache.clear
    end
  end

  test "should save product with no description" do
    setup do
      admin = User.new(:admin)
      admin.save
    end

    @product = Product.new(name: "name", price: 1000, description: "")
    @product.admin_id = User.first.id
    result = @product.save

    assert result, "did not save product with no description"

    teardown do
      Rails.cache.clear
    end
  end
end
