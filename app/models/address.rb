class Address < ApplicationRecord

  validates :postal_code, :neighborhood, :city, :state, :street, :number, presence: true
  validates :postal_code, format: { with: /\A[0-9]{5}-[0-9]{3}\z/ }
  validates :postal_code, uniqueness: { scope: :member_id }

end
