# frozen_string_literal: true

class IdentityDocument < ApplicationRecord
  include StringUtils
  attr_accessor :skip_validation

  belongs_to :identity_document_type

  validates :number, presence: true
  validates :number, uniqueness: { scope: :member_id }
  validates :number, format: { with: /\A[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}\z/ }, if: :tax_payer_type?
  validate :validate_tax_payer_number, if: :tax_payer_type?
  validate :validate_id_number, if: :id_type?
  validates :complement, presence: true, if: ->(doc) { doc.id_type? && !skip_validation }

  def tax_payer_type?
    identity_document_type.tax_payer?
  end

  def id_type?
    identity_document_type.id?
  end

  private

  def validate_tax_payer_number(validator = CPFValidator)
    errors.add(:number, :invalid) unless validator.cpf_valid?(digits_only(number))
  end

  def validate_id_number
    errors.add(:number, :invalid) unless digits_only(number).length >= 4
  end
end
