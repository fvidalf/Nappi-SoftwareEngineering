require "test_helper"

class ProductControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  # test "the truth" do
  #   assert true
  # end
  test "should post product" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    assert_difference("Product.count") do
      post products_path, 
           params: { 
             product: { 
               name: "Name",
               price: 1000,
               description: "Descripción",
             },
             admin_id: @admin.id
           }
    end
    assert_redirected_to products_path

    teardown do
      Rails.cache.clear
    end
  end

  test "should not post product with no admin_id" do
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
           }
         }

    assert_template :new
    assert_response :unprocessable_entity

    teardown do
      Rails.cache.clear
    end
  end

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

    Product.all.each do |product|
      product.destroy
    end
    
    sign_in users(:user)

    get products_path

    assert_template :index
    teardown do
      Rails.cache.clear
    end
  end

  test "should get new" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    Product.all.each do |product|
      product.destroy
    end
    
    sign_in users(:admin)

    get new_product_path

    assert_template :new
    teardown do
      Rails.cache.clear
    end
  end

  test "should get edit" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    Product.all.each do |product|
      product.destroy
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
    
    get edit_product_path(id: Product.last.id)
    assert_template :edit

    teardown do
      Rails.cache.clear
    end
  end

  test "should destroy" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    Product.all.each do |product|
      product.destroy
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

    assert_difference('Product.count', -1) do
      delete product_path(id: Product.last.id)
    end
    assert_redirected_to products_path

    teardown do
      Rails.cache.clear
    end
  end

  test "should patch product" do
    sign_in users(:admin)
    sign_in users(:user)
    User.all.each do |person|
      if person.is_admin == true
        @admin = person
      elsif person.is_admin == false
        @user = person
      end
    end

    Product.all.each do |product|
      product.destroy
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

    patch product_path(id: Product.last.id), 
          params: { 
            product: { 
              name: "Name",
              price: 500,
              description: "Descripción",
            }
          }

    assert_redirected_to products_path  

    teardown do
      Rails.cache.clear
    end
  end
end
