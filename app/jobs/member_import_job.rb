# frozen_string_literal: true

class MemberImportJob < ApplicationJob
  queue_as :member_list

  DOCUMENTS_MAP = {
    cpf: IdentityDocumentType.tax_payer_id,
    rg: IdentityDocumentType.identity_card,
    certidao_nascimento: IdentityDocumentType.birth_certificate
  }.freeze

  def perform(member_upload)
    CSVReader.new(member_upload.csv_file).each_line do |row, index|
      membership = membership(row['codigo_membro']&.strip)
      save_member(row, membership) if membership.present?
    rescue StandardError => e
      logger.error "The following error was found at line ##{index}: #{e}"
    end
  ensure
    member_upload.csv_file.purge
  end

  private

  def membership(id)
    return if id.nil?

    Membership.by_id(id).first
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def save_member(row, membership)
    member = Member.find_or_initialize_by(membership: membership)
    member.ensemble = ensemble(row)
    member.name = name(row, membership)
    member.birthdate = birthdate(row, membership)
    member.email = email(row, membership)
    member.food_restrictions = food_restrictions(row)
    member.additional_information = additional_information(row)
    member.identity_documents << identity_documents(row, member.identity_documents)
    member.phones << phones(row, member.phones)
    member.addresses << addresses(row, member.addresses)
    member.save
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def ensemble(row)
    Ensemble.by_name(row['nucleo'].strip).first
  end

  def name(row, membership)
    return membership.name if membership.name.present?

    name = row['nome'].strip
    name.present? ? name : membership.name
  end

  def birthdate(row, membership)
    return membership.birthdate if membership.birthdate.present?

    birthdate = row['data_nascimento']&.strip
    Date.strptime(birthdate, '%d/%m/%Y') if birthdate.present?
  end

  def email(row, membership)
    return membership.email if membership.email.present?

    email = row['email']&.strip
    email if email.present?
  end

  def food_restrictions(row)
    row['restricao_alimentar']&.strip
  end

  def additional_information(row)
    row['informacoes_adicionais']&.strip
  end

  def identity_documents(row, current_documents)
    identity_documents = []
    DOCUMENTS_MAP.keys.each { |key| identity_documents << identity_document(row, key) }
    identity_documents.compact.reject { |item| current_documents.pluck(:number).include?(item.number) }
  end

  def identity_document(row, type)
    return if row[type.to_s].blank?

    number, complement = row[type.to_s].strip.split(';')[0..1]
    IdentityDocument.new(number: number, complement: complement, identity_document_type: DOCUMENTS_MAP[type], skip_validation: true)
  end

  def phones(row, current_phones)
    return [] if row['telefones'].blank?

    phones = row['telefones'].strip.split('|').inject([]) do |hash, phone|
      hash << Phone.new(phone_params(phone))
    end
    phones.reject { |item| current_phones.pluck(:phone_number).include?(item.phone_number) }.uniq(&:phone_number)
  end

  def phone_params(phone_separeted_by_semicolon)
    phone_number, phone_type, additional_information = phone_separeted_by_semicolon.split(';')[0..2]
    { phone_number: phone_number, phone_type: phone_type(phone_type), additional_information: additional_information }
  end

  def phone_type(type)
    return PhoneType.home if type.present? && type.casecmp('fixo').zero?

    PhoneType.mobile
  end

  def addresses(row, current_addresses)
    return [] if row['enderecos'].blank?

    addresses = row['enderecos'].strip.split('|').inject([]) do |hash, address|
      hash << Address.new(address_params(address))
    end
    addresses.reject { |item| current_addresses.pluck(:postal_code).include?(item.postal_code) }.uniq(&:postal_code)
  end

  def address_params(address_separeted_by_semicolon)
    postal_code, street, number, additional_information, neighborhood, city, state = address_separeted_by_semicolon.split(';')[0..6]
    {
      postal_code: postal_code, street: street, number: number,
      additional_information: additional_information,
      neighborhood: neighborhood, city: city, state: state
    }
  end
end
