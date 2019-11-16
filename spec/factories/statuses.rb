# frozen_string_literal: true

FactoryBot.define do
  factory :status do
    description { 'MyString' }
    reversible { false }
    block_access { false }
  end
end
