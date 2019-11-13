# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberParser do
  describe '#parse' do
    let(:ensemble_record) { create(:ensemble) }
    let(:ensemble) { { 'nucleo': ensemble_record.name } }
    let(:membership_record) { create(:membership) }
    let(:membership) { { 'codigo_membro': membership_record.id.to_s } }
    let(:name) { { 'nome': membership_record.name } }
    let(:birthdate) { { 'data_nascimento': membership_record.birthdate.strftime('%d/%m/%Y') } }
    let(:email) { { 'email': membership_record.email } }
    let(:row) do
      build(:member_row, name: name, ensemble: ensemble, membership: membership, birthdate: birthdate, email: email)
    end

    before do
      create(:identity_document_type, description: 'RG')
      create(:identity_document_type, description: 'CPF')
      create(:identity_document_type, description: 'Certidão de Nascimento')
      create(:phone_type, description: 'Celular')
      create(:phone_type, description: 'Residencial')
      create(:phone_type, description: 'Trabalho')
    end

    subject { MemberParser.new.parse(row) }

    it { expect(subject.ensemble.name).to eq(row['nucleo']) }
    it { expect(subject.membership_id).to eq(row['codigo_membro'].to_i) }
    it { expect(subject.name).to eq(row['nome']) }
    it { expect(subject.birthdate.strftime('%d/%m/%Y')).to eq(row['data_nascimento']) }
    it { expect(subject.email).to eq(row['email']) }
    it { expect(subject.food_restrictions).to eq(row['restricao_alimentar']) }
    it { expect(subject.additional_information).to eq(row['informacoes_adicionais']) }

    context 'with phones' do
      let(:phones_stored) do
        subject.phones.inject([]) do |array, phone|
          value = "#{phone.phone_number};#{phone.phone_type.description};#{phone.additional_information}"
          array << value
        end
      end
      let(:phones_splited) { row['telefones'].split('|') }

      it { expect(phones_stored).to eq(phones_splited) }
    end

    context 'with documents' do
      let(:documents_stored) do
        subject.identity_documents.each_with_object({}) do |doc, hash|
          key = MemberParser::DOCUMENTS_MAP.key(doc.identity_document_type.description).to_s
          values = [doc.number, doc.complement].compact
          hash[key] = values.join(';')
        end
      end
      let(:documents_splited) { row.slice('cpf', 'rg', 'certidao_nascimento') }

      it { expect(documents_stored).to eq(documents_splited) }
    end

    context 'with addresses' do
      let(:addresses_stored) do
        subject.addresses.inject([]) do |array, address|
          value = address_separeted_by_semicolon(address)
          array << value
        end
      end
      let(:addresses_splited) { row['enderecos'].split('|') }

      it { expect(addresses_stored).to eq(addresses_splited) }
    end
  end

  private

  def address_separeted_by_semicolon(address, values = [])
    values << address.postal_code
    values << address.street
    values << address.number
    values << address.additional_information
    values << address.neighborhood
    values << address.city
    values << address.state
    values.join(';')
  end
end
