class Member < ApplicationRecord
  belongs_to :organizational_information, optional: true
  belongs_to :ensemble, optional: true
  has_many :phones
  has_many :emails
  has_many :addresses
  has_many :leaders
  has_many :positions, through: :leaders
end
