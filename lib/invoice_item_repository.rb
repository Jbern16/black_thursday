require_relative 'invoice_item'
require 'pry'
require_relative 'csv_loader'

class InvoiceItemRepository
  attr_accessor :invoice_items
  include CsvLoader

  def initialize(file_path=nil)
    from_csv(file_path)
  end

  def from_csv(file_path=nil)
    unless file_path.nil?
      @invoice_items = load(file_path).map do |invoice_item|
        InvoiceItem.new(invoice_item)
      end
    end
  end

  def all
    invoice_items
  end

  def find_by_id(invoice_item_id)
    invoice_items.find do |invoice_item|
      invoice_item.id.to_i == invoice_item_id.to_i
    end
  end

  def find_all_by_item_id(item_id)
    invoice_items.select do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_items.select do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end
