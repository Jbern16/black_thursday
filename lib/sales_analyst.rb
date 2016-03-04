require_relative 'sales_engine'
require_relative 'merchant_repository'
require_relative 'standard_deviator'


class SalesAnalyst
  attr_reader :items, :merchants, :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items = sales_engine.items
    @merchants = sales_engine.merchants
  end

  def average_items_per_merchant
    (items.all.length / merchants.all.length).to_f
  end

  def average_items_per_merchant_standard_deviation
    numbers_squared = merchants.all.map do |merchant|
      ((merchant.items.length) - average_items_per_merchant) ** 2
    end
    StandardDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def merchants_with_high_item_count
    one_standard_deviation = average_items_per_merchant +
    average_items_per_merchant_standard_deviation

    merchants.all.select do |merchant|
      merchant.items.length > one_standard_deviation
    end
  end

  def average_item_price_for_merchant(merchant_id)
    prices = merchants.find_by_id(merchant_id).items.map do |item|
      item.unit_price
    end
    (average_unit_price = prices.reduce(:+) / prices.length).round(2).to_f
  end

  def items_average_unit_price
    items_prices = items.all.map {|item| item.unit_price}
    (items_prices.reduce(:+) / items_prices.length).to_i
  end

  def standard_deviation_for_unit_price
    numbers_squared = items.all.map do |item|
      ((item.unit_price) - items_average_unit_price) ** 2
    end
    StandardDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def golden_items
    criteria = items_average_unit_price + standard_deviation_for_unit_price * 2
    items.all.select { |item| item.unit_price > criteria}
  end

  def average_average_price_per_merchant
    merchants.all.map(&:average_item_price).reduce(0,:+) / merchants.all.count
  end

end
