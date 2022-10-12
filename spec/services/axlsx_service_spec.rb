# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AxlsxService, type: :model do
  describe '#create_report' do
    it 'should call axlsx creator to generate the excel file' do
      response = AxlsxService.new.create_report
      expect(response.core.creator).to eq('axlsx')
    end
    it 'should create excel file with expected header' do
      response = AxlsxService.new.create_report
      generated_file = Roo::Excelx.new(response.to_stream)
      expected_header = %w[Name Email Phone]
      expect(generated_file.row(1)).to eq(expected_header)
    end
    it 'should create an excel file with 2 sheets ' do
      response = AxlsxService.new.create_report
      generated_file = Roo::Excelx.new(response.to_stream)
      expect(generated_file.sheets.count).to eq(2)
    end
    it 'should create excel file with sheet as the Location1_name' do
      response = AxlsxService.new.create_report
      generated_file = Roo::Excelx.new(response.to_stream)
      expect(generated_file.sheets).to include('Location1_name')
    end
    it 'should creeate an exel sheet with data in correct format' do
      response = AxlsxService.new.create_report
      generated_file = Roo::Excelx.new(response.to_stream)
      data_row = ["xyz", 1234567890, "xyz@gmail.com"]
      expect(generated_file.row(2)).to eq(data_row)
    end
  end
end
