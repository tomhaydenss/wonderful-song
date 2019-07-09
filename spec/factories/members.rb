FactoryBot.define do
  factory :member do
    name { Faker::Name.name }
    birthdate { Faker::Date.birthday(6, 40) }
  end
end