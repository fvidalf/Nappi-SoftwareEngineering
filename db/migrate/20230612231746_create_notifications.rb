class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :sender_user_id
      t.text :content
      t.boolean :read

      t.timestamps
    end
  end
end
