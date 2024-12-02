class RemoveChatColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :chats, :messages
  end
end
