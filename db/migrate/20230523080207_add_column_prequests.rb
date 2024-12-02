class AddColumnPrequests < ActiveRecord::Migration[7.0]
  def change
    add_column :p_requests, :status, :string
  end
end
