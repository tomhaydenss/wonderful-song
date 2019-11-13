# frozen_string_literal: true

class IdentityDocumentType < ApplicationRecord
  TAX_PAYER = 'CPF'
  ID = 'RG'
  BIRTH_CERTIFICATE = 'Certidão de Nascimento'

  validates :description, presence: true
  validates :description, uniqueness: { case_sensitive: false }

  scope :tax_payer_id, -> { find_by(description: TAX_PAYER) }
  scope :identity_card, -> { find_by(description: ID) }
  scope :birth_certificate, -> { find_by(description: BIRTH_CERTIFICATE) }

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
