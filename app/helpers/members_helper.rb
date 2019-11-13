# frozen_string_literal: true

module MembersHelper
  def self.members_as_grouped_options(members)
    members.each_with_object({}) do |member, hash|
      key = member&.ensemble&.fully_qualified_name
      value = [member.name, member.id]
      if hash[key].present?
        hash[key] << value
      else
        hash[key] = [value]
      end
    end.to_a
  end
end
