require 'csv'

class CSVReader
  include ActiveStorage::Downloading

  attr_reader :blob

  def initialize(blob)
    @blob = blob
  end

  def each_line
    download_blob_to_tempfile do |file|
      CSV.foreach(file, headers: true).with_index(2) do |row, index|
        yield row, index
      end
    end
  end
end