require_relative 'invoice'
require_relative 'csv_loader'

class InvoiceRepository
      attr_accessor :invoices
      include CsvLoader

  def initialize(file_path=nil)
    unless file_path.nil?
    @invoices = load(file_path).map { |item| Invoice.new(item)}
    end
  end

  def all
    @invoices
  end











  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
