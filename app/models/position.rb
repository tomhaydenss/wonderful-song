class Position < ApplicationRecord
  validates :description, presence: true, uniqueness: true, allow_blank: false
  validates :description, uniqueness: { case_sensitive: false }
  has_many :permissions
end
