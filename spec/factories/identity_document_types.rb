# frozen_string_literal: true

FactoryBot.define do
  DOC_TYPES = ['Birth certificate', 'Identity Card', 'Social Security Card', 'Driver\'s License', 'Passport'].freeze
  factory :identity_document_type do
    description { DOC_TYPES.sample }
  end
end
