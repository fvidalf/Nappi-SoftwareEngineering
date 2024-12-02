class AddColumnPRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :p_requests, :quantity, :integer
  end
end
