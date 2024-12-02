class Review < ApplicationRecord
  validates :user_id, presence: true
  validates :score, presence: true
  belongs_to :product, optional: true
  belongs_to :user
end
