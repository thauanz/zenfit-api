class Zentime < ApplicationRecord
  belongs_to :user

  validates :user_id, :time_record, :date_record, presence: true
  validates_numericality_of :time_record, greater_than_or_equal_to: 1
end
