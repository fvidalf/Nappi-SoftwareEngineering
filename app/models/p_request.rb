class PRequest < ApplicationRecord
  validates :request_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true
  validates :status, presence: true
  belongs_to :request
  belongs_to :product
end
