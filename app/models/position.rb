class Position < ApplicationRecord
  validates :description, presence: true, uniqueness: true, allow_blank: false
  has_many :permissions
end
