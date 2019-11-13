# frozen_string_literal: true

require 'csv'

module MembersToCsv
  extend ActiveSupport::Concern

  def to_csv(members)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      members.each do |member|
        csv << attributes.map { |attr| send(attr, member) }
      end
    end
  end

  private

  def attributes
    %w[nucleo
       codigo_membro nome email data_nascimento data_ingresso_grupo
       cpf rg certidao_nascimento restricao_alimentar telefones
       informacoes_adicionais enderecos].freeze
  end

  def nucleo(member)
    member.ensemble&.name
  end

  def codigo_membro(member)
    member.membership_id
  end

  def nome(member)
    member.name
  end

  def email(member)
    member.email
  end

  def data_nascimento(member)
    member.birthdate
  end

  def data_ingresso_grupo(member)
    member.joining_date
  end

  def cpf(member)
    docs = member.identity_documents.select { |doc| doc.identity_document_type.tax_payer? }.inject([]) do |array, doc|
      array << doc.number.to_s + (doc.complement.present? ? ";#{doc.complement}" : '')
    end
    docs.present? ? docs.join('|') : ''
  end

  def rg(member)
    docs = member.identity_documents.select { |doc| doc.identity_document_type.id? }.inject([]) do |array, doc|
      array << doc.number.to_s + (doc.complement.present? ? ";#{doc.complement}" : '')
    end
    docs.present? ? docs.join('|') : ''
  end

  def certidao_nascimento(member)
    docs = member.identity_documents.select { |doc| doc.identity_document_type.birth_certificate? }.inject([]) do |array, doc|
      array << doc.number.to_s + (doc.complement.present? ? ";#{doc.complement}" : '')
    end
    docs.present? ? docs.join('|') : ''
  end

  def restricao_alimentar(member)
    member.food_restrictions
  end

  def telefones(member)
    phones = member.phones.inject([]) do |array, phone|
      array << "#{phone.phone_number};#{phone.phone_type.description}" + phone_additional_information(phone)
    end
    phones.present? ? phones.join('|') : ''
  end

  def phone_additional_information(phone)
    phone.additional_information.present? ? ";#{phone.additional_information}" : ''
  end

  def informacoes_adicionais(member)
    member.additional_information
  end

  def enderecos(member)
    addressess = member.addresses.inject([]) do |array, address|
      array << address_attributes.map { |attr| address.send(attr) }.join(';')
    end
    addressess.present? ? addressess.join('|') : ''
  end

  def address_attributes
    %w[postal_code street number additional_information neighborhood city state].freeze
  end
end
