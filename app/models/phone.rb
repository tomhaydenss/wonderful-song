class Phone < ApplicationRecord
  belongs_to :phone_type

  validates :phone_number, presence: true
  validates :phone_number, format: { with: /\A[(][0-9]{2}[)] [9]?[0-9]{4}-[0-9]{4}\z/ }

  validates_uniqueness_of :phone_number, scope: [:member_id]
  
end
