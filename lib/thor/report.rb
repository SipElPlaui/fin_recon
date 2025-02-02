require_relative 'logging'
require 'spreadsheet'

module Thor
  # Produce the report on the specified instruments
  class Report
    def initialize
      @report = Spreadsheet::Workbook.new
      @work_sheet = @report.create_worksheet name: 'Tickers'
      @errors_sheet = @report.create_worksheet name: 'Not found'
      @work_offset = 1
      @errors_offset = 1

      @work_sheet.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold, size: 10
      @work_sheet.row(0).replace ['Ticker', 'Name', 'Country', 'Industry', 'Market cap', 'Price', 'P/E',
                                  'EPS', 'Dividend yield']
    end

    def add(ticker:, stats:)
      @work_sheet.row(@work_offset).replace [ticker.rts_code,
                                             ticker.name,
                                             ticker.country,
                                             ticker.industry,
                                             stats.market_cap,
                                             stats.price,
                                             stats.pe_ratio,
                                             stats.eps,
                                             stats.dividend_yield]
      @work_offset += 1
    end

    def not_found(name:)
      @errors_sheet.row(@errors_offset).replace [name]
      @errors_offset += 1
    end

    def write(filename)
      @report.write filename
    end
  end
end
