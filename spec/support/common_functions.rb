# frozen_string_literal: true

module CommonFunctions
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
