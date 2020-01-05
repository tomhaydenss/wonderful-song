# frozen_string_literal: true

FactoryBot.define do
  factory :musical_instrument do
    description { Faker::Music.instrument }
  end
end
