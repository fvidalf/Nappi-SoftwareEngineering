class AddReferenceFromUserToRequest < ActiveRecord::Migration[7.0]
  def change
    add_reference :requests, :user, foreign_key: true
  end
end
