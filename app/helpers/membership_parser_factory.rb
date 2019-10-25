# frozen_string_literal: true

class MembershipParserFactory
  def self.for(headers)
    return FullMembershipParser.new if headers.include?('Última RP') && headers.include?('Shakubukus')

    PartialMembershipParser.new
  end
end
