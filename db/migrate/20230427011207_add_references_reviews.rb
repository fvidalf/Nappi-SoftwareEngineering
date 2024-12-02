class AddReferencesReviews < ActiveRecord::Migration[7.0]
  def change
    add_reference :reviews, :product, foreign_key: true, null: true
    change_column_null :reviews, :user_id, false
  end
end
