class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.text :description
      t.datetime :date
      t.string :status

      t.timestamps
    end
  end
end
