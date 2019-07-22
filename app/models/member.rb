class Member < ApplicationRecord
  belongs_to :organizational_information, optional: true
  belongs_to :ensemble, optional: true
  has_many :phones, dependent: :delete_all
  has_many :emails, dependent: :delete_all
  has_many :addresses, dependent: :delete_all
  has_many :identity_documents, dependent: :delete_all
  has_many :leaders
  has_many :leader_roles, through: :leaders

  accepts_nested_attributes_for :identity_documents, :phones, :emails, :addresses, :reject_if => :all_blank, :allow_destroy => true
end
