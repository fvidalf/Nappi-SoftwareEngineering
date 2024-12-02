class Request < ApplicationRecord
  validates :date, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
  belongs_to :user
  has_many :p_requests, dependent: :destroy
  has_many :products, through: :p_requests
end
