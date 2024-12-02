class Notification < ApplicationRecord
  validates :content, presence: true
  validates :sender_user_id, presence: true
  belongs_to :user
  after_create_commit {broadcast_update_to(User.find(user_id), :notifications, target: "notice_wrapper")}
end
