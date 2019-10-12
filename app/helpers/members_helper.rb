module MembersHelper
  def self.members_as_grouped_options(members)
    hash = {}
    members.each do |member|
      key = member&.ensemble&.fully_qualified_name
      value = [member.name, member.id]
      if hash[key].present?
        hash[key] << value
      else
        hash[key] = [value]
      end
    end
    hash.to_a
  end
end
