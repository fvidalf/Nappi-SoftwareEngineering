class Chat < ApplicationRecord
  validates :admin_id, presence: true
  has_many :messages, dependent: :destroy
  belongs_to :user
end
