class DataImportCsv
  include ActiveModel::Model
  require 'roo'
  require 'csv'
  require 'xsv'

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
    # @city_name = file.original_filename.split(/\W/).shift.titleize
    case File.extname(file.original_filename)
    # when ".csv" then Roo::CSV.new(file.path, nil, :ignore)
    # when ".xls" then Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Spreadsheet.open(file.path)
      # else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_imported_data
    current_user = Current.user
    spreadsheet = open_spreadsheet
    binding.pry
    header = spreadsheet.row(1)
    arr = ["Shape", "Col", "Clarity", "CUT", "POL", "SYM", "FLO", "Crown Height"]
    arr.each do |i|
      binding.pry
      index = header.find_index(i)
      if !index.nil?
        col = spreadsheet.column(index + 1)
        col.shift
        col.uniq!
        value_mapping.store(i, col)
      else
        next
      end
    end

    # ["Shape", "Col", "Clarity", "CUT", "POL", "SYM", "FLO", "Crown Height"]

    # city = City.find_or_create_by(name: @city_name, user_id: current_user.id)
    # len = spreadsheet.sheets.length - 1
    # (0..len).each do |num|
    #   @location_name = spreadsheet.sheets[num].titleize
    #   location = Location.find_or_create_by(name: @location_name, city_id: city.id, user_id: current_user.id)
    #   customer = []
    #   (2..spreadsheet.sheet(num).last_row).map do |i|
    #     next if spreadsheet.sheet(num).row(i).map(&:nil?).include?(true)

    #     row = Hash[[header, spreadsheet.sheet(num).row(i)].transpose]
    #     row['Phone'] = row['Phone'].to_s.split('.').shift
    #     customer_attributes = row.to_hash.transform_keys(&:downcase).merge!(location_id: location.id,
    #                                                                         user_id: current_user.id)
    #     customer << customer_attributes
    #   end
    #   final_customer = customer.uniq
    #   Customer.import final_customer, validate: true, validate_uniqueness: true
    # end
  end

  def imported_data
    @imported_data ||= load_imported_data
  end
end
