class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :zentimes, dependent: :destroy

  ROLES = %w(regular manager admin).freeze

  enum role: ROLES

  validates :name, :role, presence: true
end
