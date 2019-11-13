# frozen_string_literal: true

FactoryBot.define do
  factory :member_row, class: Hash do
    ensemble { { 'nucleo': build(:ensemble).name } }
    membership_id { { 'codigo_membro': build(:membership_id).to_s } }
    name { { 'nome': Faker::Name.name } }
    email { { 'email': Faker::Internet.email } }
    birthdate { { 'data_nascimento': Faker::Date.in_date_period.strftime('%d/%m/%Y') } }
    tax_payer { { 'cpf': build(:identity_document, :tax_payer_id).number } }
    id do
      id = build(:identity_document, :id)
      { 'rg': "#{id.number};#{id.complement}" }
    end
    birth_certificate { { 'certidao_nascimento': Faker::IDNumber.spanish_foreign_citizen_number } }
    food_restrictions { { 'restricao_alimentar': Faker::Food.ingredient } }
    phones do
      phone_list = build_list(:phone, rand(1..3)).inject([]) do |array, phone|
        phone_type = phone.phone_type.description == 'Residencial' ? 'Residencial' : 'Celular'
        array << "#{phone.phone_number};#{phone_type};#{phone.additional_information}"
      end
      { 'telefones': phone_list.join('|') }
    end
    additional_information { { 'informacoes_adicionais': '' } }
    addresses do
      address_list = build_list(:address, rand(1..2)).inject([]) do |array, address|
        array << address_separeted_by_semicolon(address)
      end
      { 'enderecos': address_list.join('|') }
    end

    trait :without_birthdate do
      birthdate { { 'data_nascimento': '' } }
    end

    trait :without_phones do
      phones { { 'telefones': '' } }
    end

    initialize_with do
      attributes.values.inject({}) { |hash, item| hash.merge(item) }.stringify_keys
    end
  end
end
