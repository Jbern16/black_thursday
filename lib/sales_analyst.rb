require_relative 'sales_engine'
require_relative 'merchant_repository'
require_relative 'standard_deviator'
require_relative 'sales_analyst_basic_operations'
require 'time'


class SalesAnalyst
  attr_reader :items, :merchants, :sales_engine, :invoices,
              :transactions, :customers, :invoice_items

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items = sales_engine.items
    @merchants = sales_engine.merchants
    @invoices = sales_engine.invoices
    @invoice_items = sales_engine.invoice_items
    @transactions = sales_engine.transactions
    @customers = sales_engine.customers
  end

  def average_items_per_merchant
    BasicOperations.average_by_quantity(items,merchants)
  end

  def average_items_per_merchant_standard_deviation
    numbers_squared = merchants.all.map do |merchant|
      ((merchant.items.length) - average_items_per_merchant) ** 2
    end
    StdDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def merchants_with_high_item_count
    mean = average_items_per_merchant
    stddev = average_items_per_merchant_standard_deviation
    merchants.all.select do |merchant|
      merchant.items.length > StdDeviator.deviations(1,mean,stddev)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    prices = merchants.find_by_id(merchant_id).items.map do |item|
      item.unit_price
    end
    mean = (average_unit_price = prices.reduce(:+) / prices.length).round(2)
    BigDecimal.new(mean)
  end

  def items_average_unit_price
    items_prices = items.all.map {|item| item.unit_price}
    (items_prices.reduce(:+) / items_prices.length).to_i
  end

  def standard_deviation_for_unit_price
    numbers_squared = items.all.map do |item|
      ((item.unit_price) - items_average_unit_price) ** 2
    end
    StdDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def golden_items
    mean = items_average_unit_price
    stddev = standard_deviation_for_unit_price
    criteria = StdDeviator.deviations(2, mean, stddev)

    items.all.select {|item| item.unit_price > criteria}
  end

  def average_average_price_per_merchant
    avg_price = merchants.all.map(&:average_item_price)
    mean = (avg_price.reduce(0,:+) / merchants.all.count)
    mean.round(2)
  end

  def average_invoices_per_merchant
    BasicOperations.average_by_quantity(invoices, merchants)
  end

  def average_invoices_per_merchant_standard_deviation
    numbers_squared = merchants.all.map do |merchant|
      ((merchant.invoices.length) - average_invoices_per_merchant) ** 2
    end

    StdDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def bottom_merchants_by_invoice_count
    mean = average_invoices_per_merchant
    stddev = average_invoices_per_merchant_standard_deviation
    criteria = StdDeviator.deviations(-2,mean,stddev)

    merchants.all.select {|merchant| merchant.invoices.count < criteria}
  end

  def top_merchants_by_invoice_count
    mean = average_invoices_per_merchant
    stddev = average_invoices_per_merchant_standard_deviation
    criteria = StdDeviator.deviations(2,mean,stddev)

    merchants.all.select {|merchant| merchant.invoices.count > criteria}
  end

  def top_days_by_invoice_count
    mean = invoices.average_invoices_per_day
    stddev = invoices.standard_deviation_of_days
    criteria = StdDeviator.deviations(1,mean,stddev)

    invoices.invoice_count_per_day_of_week.map do |day, count|
       day if count > criteria
    end.compact
  end

  def invoice_status(status)
    status_count = invoices.all.select do |invoice|
      invoice.status == status
    end.count

    percent_decimal = status_count.to_f / invoices.all.count
    (percent_decimal * 100).round(2)
  end

  def total_revenue_by_date(date)
    invoice_totals = invoices.date_finder(date).map(&:total)
    invoice_totals.reduce(:+)
  end

  def top_revenue_earners(number_of_merchants=20)
    merchants_ranked_by_revenue[0..number_of_merchants-1]
  end

  def revenue_by_merchant(merchant_id)
    merchants.find_by_id(merchant_id).revenue
  end

  def merchants_with_pending_invoices
    merchants.all.select do |merchant|
      merchant.any_failed_invoice_transactions?
    end
  end

  def merchants_with_only_one_item
    merchants.all.select do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants.all.select do |merchant|
      if Time.parse(merchant.created_at).month == Date::MONTHNAMES.index(month)
        merchant.items.length == 1
      end
    end
  end

  def merchants_ranked_by_revenue
    merchants.all.sort_by do |merchant|
      merchant.revenue ? -(merchant.revenue) : 0
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    paid_invoice_items = find_invoice_items(merchant_id)
    max_items = max_items(paid_invoice_items,'quantity')

    max_items.keys.map {|id| items.find_by_id(id)}
  end

  def max_items_by_quantity(table)
    max_value = table.values.max
    table.select {|id, amount| amount == max_value}
  end

  def find_invoice_items(merchant_id)
    merchant = merchants.find_by_id(merchant_id)
    merchant.paid_merchant_invoices.map do |paid_invoice|
      invoice_items.find_all_by_invoice_id(paid_invoice.id)
    end.flatten
  end

  def max_items(paid_invoice_items, function)
    table = paid_invoice_items.each_with_object(Hash.new(0)) do |inv_itm, itms|
      if function == 'total'
        itms[inv_itm.item_id] += inv_itm.total_price
      elsif function == 'quantity'
        itms[inv_itm.item_id] += inv_itm.quantity
      end
    end
    max_items_by_quantity(table)
  end

  def best_item_for_merchant(merchant_id)
    paid_invoice_items = find_invoice_items(merchant_id)
    best_item_id = max_items(paid_invoice_items,'total').keys.first

    items.find_by_id(best_item_id)
  end
end
