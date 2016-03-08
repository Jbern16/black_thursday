require 'pry'

class Merchant
  attr_reader :id, :name

  attr_accessor :items, :invoices, :customers, :created_at, :updated_at

  def initialize(data)
    @id = data[:id].to_i
    @name = data[:name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @items = []
    @invoices = []
    @customers = []
  end

  def average_item_price
    if items.any?
      items.map(&:unit_price).reduce(0,:+) / items.length
    else
      0
    end
  end

  def inspect
    "#<#{self.class}>"
  end

  def revenue
    invoices.map do |invoice|
      if invoice.transactions.any?(&:success)
        invoice.invoice_items.reduce(0) do |sum, invoice_item|
          # binding.pry
          sum += (invoice_item.unit_price * invoice_item.quantity)
          sum
        end
      end
    end.compact.reduce(:+)
  end


  def invoice_status(status)
    invoices.all? do |invoice|
      invoice.status == status
    end
  end

  def paid_merchant_invoices
    invoices.select do |invoice|
      invoice.is_paid_in_full?
    end
  end

  def any_failed_invoice_transactions?
    invoices.any? do |invoice|
      invoice.failed_transaction?
    end
  end

end
