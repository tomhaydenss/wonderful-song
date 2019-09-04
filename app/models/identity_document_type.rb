class IdentityDocumentType < ApplicationRecord
  scope :tax_payer_id, -> { where(description: 'CPF').first }
  scope :identity_card, -> { where(description: 'RG').first }
  scope :birth_certificate, -> { where(description: 'Certidão de Nascimento').first }
end
