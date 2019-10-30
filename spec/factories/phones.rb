# frozen_string_literal: true

FactoryBot.define do
  factory :phone do
    phone_number { Faker::PhoneNumber.phone_number }
    phone_type { build(:phone_type) }
  end
end
