# frozen_string_literal: true

class MemberImportJob < ApplicationJob
  queue_as :member_list

  def perform(member_upload, parser = MemberParser.new)
    CSVReader.new(member_upload.csv_file).each_line do |row, index|
      member = parser.parse(row)
      member.save if member.present?
    rescue StandardError => e
      logger.error "The following error was found at line ##{index}: #{e}"
    end
  ensure
    member_upload.csv_file.purge
  end
end
