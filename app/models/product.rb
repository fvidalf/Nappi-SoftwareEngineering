class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :admin_id, presence: true
  has_many :p_requests, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :admin, :class_name => "User" 
  include ImageUploader::Attachment(:image)
end
