class Member < ApplicationRecord
  belongs_to :organizational_information, optional: true
  belongs_to :ensemble, optional: true
  has_many :phones
  has_many :emails
  has_many :addresses
  has_many :leaderships
  has_many :positions, through: :leaderships

  accepts_nested_attributes_for :phones, :emails, :addresses, :reject_if => :all_blank, :allow_destroy => true
end
