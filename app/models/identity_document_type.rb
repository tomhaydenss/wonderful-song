class IdentityDocumentType < ApplicationRecord
  TAX_PAYER = 'CPF'
  ID = 'RG'
  BIRTH_CERTIFICATE = 'Certidão de Nascimento'

  validates :description, presence: true
  validates :description, uniqueness: { case_sensitive: false }

  scope :tax_payer_id, -> { where(description: TAX_PAYER).first }
  scope :identity_card, -> { where(description: ID).first }
  scope :birth_certificate, -> { where(description: BIRTH_CERTIFICATE).first }

  def tax_payer?
    description == TAX_PAYER
  end

  def id?
    description == ID
  end

  def birth_certificate?
    description == BIRTH_CERTIFICATE
  end
end
