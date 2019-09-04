class Address < ApplicationRecord

  validates :postal_code, :neighborhood, :city, :state, :street, :number, presence: true
  validates :postal_code, format: { with: /\A[0-9]{8}\z/ }

  validates_uniqueness_of :postal_code, scope: [:member_id]

end
