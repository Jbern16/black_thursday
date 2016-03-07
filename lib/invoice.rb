require 'time'

class Invoice
  attr_reader :id, :unit_price, :created_at,
              :updated_at, :customer_id,
              :status, :merchant_id

  attr_accessor :merchant, :items, :transactions, :customer

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
    binding.pry
    status = transactions.all? do |transaction|
      transaction.result == "success"
    end

    if status
      return unit_price
    else
      item.unit_price.reduce(:+)
    end
  end



end
