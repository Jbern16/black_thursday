require_relative 'invoice'
require_relative 'csv_loader'
require_relative 'standard_deviator'

class InvoiceRepository
  attr_accessor :invoices
  include CsvLoader

  def initialize(file_path=nil)
    unless file_path.nil?
      @invoices = load(file_path).map { |item| Invoice.new(item)}
    end
  end

  def all
    invoices
  end

  def find_by_id(invoice_id)
    invoices.find do |invoice|
      invoice.id.to_i == invoice_id.to_i
    end
  end

  def find_all_by_customer_id(customer_id)
    invoices.select do |invoice|
      invoice.customer_id.to_i == customer_id.to_i
    end
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.select do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    invoices.select do |invoice|
      invoice.status == status
    end
  end

  def average_invoices_per_day
    (all.length / 7.0).round(2)
  end

  def invoice_count_per_day_of_week
    invoices.reduce(Hash.new(0)) do |days, invoice|
      days[invoice.created_at.strftime("%A")] += 1
      days
    end
  end

  def standard_deviation_of_days
    numbers_squared = invoice_count_per_day_of_week.values.map do |day|
      (day - average_invoices_per_day) ** 2
    end

    numbers_squared[0] = numbers_squared.join.to_f.round(2)
    StdDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def date_finder(date)
    invoices.select do |invoice|
      invoice.created_at.strftime("%Y-%m-%d") == date.strftime("%Y-%m-%d")
    end
  end

  def inspect
    "#<#{self.class} #{merchants.size} rows>"
  end
end
