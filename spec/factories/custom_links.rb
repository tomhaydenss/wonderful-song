# frozen_string_literal: true

FactoryBot.define do
  factory :custom_link do
    add_attribute(:alias) { Faker::Internet.url.split('/').last }
    title { Faker::Internet.url.split('/').last }
    url { Faker::Internet.url }
  end
end
