require 'csv'

module MembersToCsv
  extend ActiveSupport::Concern

  def to_csv(members)
    CSV.generate(headers: true) do |csv|
      csv << attributes = %w(nucleo codigo_membro nome email data_nascimento data_ingresso_grupo cpf rg certidao_nascimento restricao_alimentar telefones observacao enderecos)
      members.each do |member|
        csv << attributes.map{ |attr| self.send(attr, member) }
      end
    end
  end

  private
  
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
      array << "#{doc.number}" + (doc.complement.present? ? ";#{doc.complement}" : '')
    end
    docs.present? ? docs.join('|') : ''
  end
  
  def rg(member)
    docs = member.identity_documents.select { |doc| doc.identity_document_type.id? }.inject([]) do |array, doc|
      array << "#{doc.number}" + (doc.complement.present? ? ";#{doc.complement}" : '')
    end
    docs.present? ? docs.join('|') : ''
  end
            
  def certidao_nascimento(member)
    docs = member.identity_documents.select { |doc| doc.identity_document_type.birth_certificate? }.inject([]) do |array, doc|
      array << "#{doc.number}" + (doc.complement.present? ? ";#{doc.complement}" : '')
    end
    docs.present? ? docs.join('|') : ''
  end
  
  def restricao_alimentar(member)
    member.food_restrictions
  end

  def telefones(member)
    phones = member.phones.inject([]) do |array, phone|
      array << "#{phone.phone_number};#{phone.phone_type.description}" + (phone.additional_information.present? ? ";#{phone.additional_information}" : '')
    end
    phones.present? ? phones.join('|') : ''
  end
  
  def observacao(member)
    member.additional_information
  end
  
  def enderecos(member)
    addressess = member.addresses.inject([]) do |array, addr|
      array << "#{addr.postal_code};#{addr.street};#{addr.number};#{addr.additional_information};#{addr.neighborhood};#{addr.city};#{addr.state}"
    end
    addressess.present? ? addressess.join('|') : ''
  end
end