# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    postal_code { Faker::Address.zip_code }
    street { Faker::Address.street_name }
    number { Faker::Address.street_address.split.first }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    additional_information { Faker::Address.secondary_address }
  end
end
