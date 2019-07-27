class Leader < ApplicationRecord
  belongs_to :ensemble
  belongs_to :member
  has_many :leader_roles, dependent: :delete_all
  has_many :positions, through: :leader_roles

  accepts_nested_attributes_for :leader_roles, reject_if: :all_blank, allow_destroy: true
end
