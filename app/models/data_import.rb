class DataImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
    rescue StandardError
      nil
  end

  def persisted?
    false
  end

  def open_spreadsheet
    @city_name = file.original_filename.split(/\W/).shift.titleize
    case File.extname(file.original_filename)
    when '.csv' then Csv.new(file.path, nil, :ignore)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_imported_data
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    city = City.find_or_create_by(name: @city_name)
    len = spreadsheet.sheets.length - 1
    (0..len).each do |num|
      @location_name = spreadsheet.sheets[num].titleize
      location = Location.find_or_create_by(name: @location_name, city_id: city.id)
      user = []
      (2..spreadsheet.sheet(num).last_row).map do |i|
        row = Hash[[header, spreadsheet.sheet(num).row(i)].transpose]
        row['Phone'] = row['Phone'].to_s.split('.').shift
        user_attributes = row.to_hash.transform_keys(&:downcase).merge!(location_id: location.id)
        user << user_attributes
      end
      final_user = user.uniq
      Customer.import final_user, validate: true, validate_uniqueness: true
    end
  end

  def imported_data
    @imported_data ||= load_imported_data
  end
end
