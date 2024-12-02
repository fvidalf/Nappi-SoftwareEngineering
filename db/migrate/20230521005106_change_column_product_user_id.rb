class ChangeColumnProductUserId < ActiveRecord::Migration[7.0]
  def change
    rename_column :products, :user_id, :admin_id
  end
end
