class ChangeReviewProductNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :reviews, :product_id, true
  end
end
