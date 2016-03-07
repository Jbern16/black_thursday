require 'time'

class Invoice
  attr_reader :id, :unit_price, :created_at,
              :updated_at, :customer_id,
              :status, :merchant_id

  attr_accessor :merchant, :items, :transactions, :customer

  def initialize(data)
    @id = data[:id].to_i
    @unit_price = data[:unit_price]
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
    @customer_id = data[:customer_id].to_i
    @status = data[:status].to_sym
    @merchant_id = data[:merchant_id].to_i

    @merchant = nil
    @items = []
    @transactions = []
    @customer = nil
  end

  def inspect
    "#<#{self.class}>"
  end
end
