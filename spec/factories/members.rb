# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    name { Faker::Name.name }
    birthdate { Faker::Date.between(from: 36.years.ago, to: 4.years.ago).strftime('%F') }
    joining_date { Faker::Date.between(from: birthdate, to: 4.years.ago).strftime('%F') }
    food_restrictions { Faker::Food.ingredient }
    email { Faker::Internet.email }
    membership { build(:membership) }

    trait :with_phone do
      phones { [build(:phone)] }
    end

    trait :with_address do
      addresses { [build(:address)] }
    end

    trait :with_identity_document do
      identity_documents { [build(:identity_document)] }
    end

    factory :with_phone_address_and_document, traits: [:with_phone, :with_address, :with_identity_document]
  end
end
