# frozen_string_literal: true

FactoryBot.define do
  factory :position do
    description { Faker::Military.army_rank }
  end
end
