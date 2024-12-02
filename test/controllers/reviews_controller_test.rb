require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  test "should post review" do
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

    sign_in users(:user)

    assert_difference("Review.count") do
      post reviews_path, 
           params: {
             review: {
               score: 5,
               content: "good"
             },
             user_id: @user.id,
             product_id: Product.last.id
           }
    end

    teardown do
      Rails.cache.clear
    end
  end

  test "should get new_product_review" do
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

    sign_in users(:user)

    get new_product_review_path,
        params: {
          user_id: @user.id,
          product_id: Product.last.id
        }

    assert_template :new_product_review
  end

  test "should delete review" do
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

    sign_in users(:user)
    post reviews_path, 
         params: {
           review: {
             score: 5,
             content: "good"
           },
           user_id: @user.id,
           product_id: Product.last.id
         }

    sign_in users(:admin)
    @product_id = Review.last.product_id
    assert_difference("Review.count", -1) do
      delete review_path(id: Review.last.id)
    end
    teardown do
      Rails.cache.clear
    end
    assert_redirected_to product_path(@product_id)
  end
end
