require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save review with complete params" do
    setup do
      user = User.new(:user)
      user.save

      admin = User.new(:admin)
      admin.save

      product = Product.new(name: "name", price: 1000, description: "Descripción")
      product.admin_id = User.all[1].id
      product.save
    end

    new_review = Review.new(score: 5, content: "decent")
    new_review.user_id = User.all[0].id
    new_review.product_id = Product.first.id
    result = new_review.save

    assert result, "did not save review with complete params"

    teardown do
      Rails.cache.clear
    end
  end

  test "should save review with no product id" do
    setup do
      user = User.new(:user)
      user.save
    end

    review1 = Review.new(score: 5, content: "decent")
    review1.user_id = User.all[0].id
    result = review1.save

    assert result, "did not save review with no product id"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save review with no user id" do
    review1 = Review.new(score: 5, content: "decent")
    result = review1.save

    assert_not result, "saved review with no user id"

    teardown do
      Rails.cache.clear
    end
  end

  test "should not save review with no score" do
    setup do
      user = User.new(:user)
      user.save
    end

    review1 = Review.new(score: nil, content: "decent")
    review1.user_id = User.all[0].id
    result = review1.save

    assert_not result, "saved review with no score"

    teardown do
      Rails.cache.clear
    end
  end

  test "should delete review" do
    setup do
      user = User.new(:user)
      user.save
    end

    review1 = Review.new(score: 5, content: "decent")
    review1.user_id = User.all[0].id
    review1.save

    review2 = Review.new(score: 7, content: "good")
    review2.user_id = User.all[0].id
    review2.save

    assert_difference("Review.count", -1) do
      review1.destroy
    end

    teardown do
      Rails.cache.clear
    end
  end
end
