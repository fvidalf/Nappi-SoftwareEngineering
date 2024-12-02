class CreatePRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :p_requests do |t|
      t.references :request, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
