class Message < ApplicationRecord
  # validates :content
  belongs_to :user
  belongs_to :chat
  after_create_commit {broadcast_append_to(chat, :messages)}
end
