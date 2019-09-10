class MembershipImportJob < ApplicationJob
  queue_as :membership_list

  def perform(membership_upload)
    file = CSVReader.new(membership_upload.csv_file)
    parser = MembershipParserFactory.for(file.headers)
    file.each_line do |row, index|
      begin
        membership = parser.parse(row)
        membership.save if membership.present?
      rescue StandardError => e
        logger.error "The following error was found at line ##{index}: #{e}"
      end
    end
  ensure
    membership_upload.csv_file.purge
  end
end
