class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :requests, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :products, :foreign_key => "admin_id", :class_name => "Product", dependent: :destroy
  include ImageUploader::Attachment(:image)
  has_many :notifications
end
