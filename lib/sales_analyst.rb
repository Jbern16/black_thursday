require_relative 'sales_engine'

class SalesAnalyst
  attr_reader :items, :merchants

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items = sales_engine.items
    @merchants = sales_engine.merchants
  end

  def average_items_per_merchant
    (items.length / merchants.length).to_f
  end

  def average_items_per_merchant_standard_deviation
    numbers_squared = merchants.map do |merchant|
      ((merchant.items.length) - average_items_per_merchant) ** 2
    end

    Math.sqrt((numbers_squared.reduce(:+) / (numbers_squared.length - 1)))
  end

  

end
