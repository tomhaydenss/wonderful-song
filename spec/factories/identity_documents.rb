# frozen_string_literal: true

FactoryBot.define do
  factory :identity_document do
    identity_document_type { build(:identity_document_type) }
    number { Faker::IDNumber.valid }

    trait :id do
      identity_document_type { build(:identity_document_type, description: 'RG') }
      number { Faker::IDNumber.brazilian_id(formatted: true) }
      complement { "SSP-#{Faker::Address.state_abbr}" }
    end

    trait :tax_payer_id do
      identity_document_type { build(:identity_document_type, description: 'CPF') }
      number { Faker::IDNumber.brazilian_citizen_number(formatted: true) }
    end
  end
end
