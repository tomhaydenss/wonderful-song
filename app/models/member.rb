class Member < ApplicationRecord
  belongs_to :organizational_information, optional: true
  belongs_to :ensemble, optional: true
  has_one :user
  has_many :phones
  has_many :emails
  has_many :addresses
  has_many :identity_documents
  has_many :leaderships
  has_many :positions, through: :leaderships

  accepts_nested_attributes_for :identity_documents, :phones, :emails, :addresses, :reject_if => :all_blank, :allow_destroy => true
end
