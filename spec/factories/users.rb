FactoryBot.define do
  factory :user do
    member { create(:member) }
    email { Faker::Internet.email }
    password { '123123' }
  end
end