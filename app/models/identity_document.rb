class IdentityDocument < ApplicationRecord
  belongs_to :identity_document_type

  validates :number, presence: true
  validates :number, format: { with: /\A[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}\z/ }, if: :tax_payer_type?
  validates :number, uniqueness: { scope: :member_id }

  def tax_payer_type?
    identity_document_type.tax_payer?
  end
end
