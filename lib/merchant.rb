require 'pry'

class Merchant
  attr_reader :id,
              :name
  attr_accessor :items, :invoices, :customers

  def initialize(data)
    @id = data[:id].to_i
    @name = data[:name]
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
      invoice.invoice_items.reduce(0) do |sum, invoice_item|
        sum += invoice_item.unit_price
        sum
      end
    end.reduce(:+)
  end


  def invoice_status(status)
    invoices.any? do |invoice|
      invoice.status == status
    end
  end

end
