require_relative 'invoice_item'
require 'pry'
require_relative 'csv_loader'

class InvoiceItemRepository
  attr_accessor :invoice_items

  include CsvLoader

  def from_csv(file_path=nil, items, invoices)
    unless file_path.nil?
      @invoice_items = load(file_path).map do |invoice_item|
        InvoiceItem.new(invoice_item)
      end
    end
    binding.pry
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

  def something(invoice_id, item_id)
    invoices = invoices.find_by_invoice_id(invoice_id)
    items = items.find_by_item_id

    invoices.items = []
    

end
