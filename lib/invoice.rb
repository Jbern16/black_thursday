require 'time'

class Invoice
  attr_reader :id, :unit_price, :created_at,
              :updated_at, :customer_id,
              :status, :merchant_id
  attr_accessor :merchant, :items, :transactions, :customer, :invoice_items

  def initialize(data)
    @id = data[:id].to_i
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
    @customer_id = data[:customer_id].to_i
    @status = data[:status].to_sym
    @merchant_id = data[:merchant_id].to_i

    @merchant = nil
    @items = []
    @transactions = []
    @customer = nil
    @invoice_items = []
  end

  def inspect
    "#<#{self.class}>"
  end

  def is_paid_in_full?
    transactions.any? do |transaction|
      transaction.result == "success"
    end
  end

  def total
    if is_paid_in_full?
      invoice_items.reduce(0) do |total, invoice_item|
      total_price = invoice_item.quantity * invoice_item.unit_price
      total += total_price
      end
    end
  end

  def failed_transaction?
    transactions.all? do |transaction|
      transaction.result == "failed"
    end
  end
end
