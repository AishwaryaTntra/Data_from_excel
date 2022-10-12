class AxlsxService
  def create_report
    Axlsx::Package.new do |p|
      wb = p.workbook
      i = 1
      2.times do
        wb.add_worksheet(name: "Location#{i}_name") do |sheet|
          sheet.add_row %w[Name Email Phone]
          sheet.add_row ['xyz', '1234567890', 'xyz@gmail.com']
          sheet.add_row ['abc', '1234567809', 'abc@gmail.com']
        end
        i += 1
      end
      p.serialize('City_name.xlsx')
    end
  end
end
