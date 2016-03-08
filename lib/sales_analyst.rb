require_relative 'sales_engine'
require_relative 'merchant_repository'
require_relative 'standard_deviator'
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
    (items.all.length.to_f / merchants.all.length.to_f).round(2)
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
    StandardDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def golden_items
    criteria = items_average_unit_price + standard_deviation_for_unit_price * 2
    items.all.select { |item| item.unit_price > criteria}
  end

  def average_average_price_per_merchant
    avg_price = merchants.all.map(&:average_item_price)
    mean = (avg_price.reduce(0,:+) / merchants.all.count)
    mean.round(2)
  end

  def average_invoices_per_merchant
     ((invoices.all.length.to_f) / (merchants.all.length.to_f)).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    numbers_squared = merchants.all.map do |merchant|
      ((merchant.invoices.length) - average_invoices_per_merchant) ** 2
    end

    StandardDeviator.square_root_of_sum_divided_by(numbers_squared)
  end

  def bottom_merchants_by_invoice_count
    criteria = average_invoices_per_merchant +
    average_invoices_per_merchant_standard_deviation * -2

    merchants.all.select { |merchant| merchant.invoices.count < criteria}
  end

  def top_merchants_by_invoice_count
    criteria = average_invoices_per_merchant +
    average_invoices_per_merchant_standard_deviation * 2

    merchants.all.select { |merchant| merchant.invoices.count > criteria}
  end

  def top_days_by_invoice_count
    criteria = invoices.average_invoices_per_day +
    invoices.standard_deviation_of_days

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
    item_id_and_count = item_id_with_count(paid_invoice_items)
    selected_items = group(item_id_and_count).select { |x| x.class == String}
    selected_items.map {|item_id| items.find_by_id(item_id.to_i)}
  end

  def group(item_id_and_count)
    item_id_and_count.group_by do |key, value|
      key = key
      value
    end.max.flatten
  end

  def find_invoice_items(merchant_id)
    merchant = merchants.find_by_id(merchant_id)
    merchant.paid_merchant_invoices.map do |paid_invoice|
      invoice_items.find_all_by_invoice_id(paid_invoice.id)
    end.flatten
  end

  def item_id_with_count(paid_invoice_items, multiplier=nil)
    paid_invoice_items.reduce({}) do |item_hash, invoice_item|
      id = invoice_item.item_id
      unit_by_quantity = (invoice_item.quantity * invoice_item.unit_price)
      item_hash[id.to_s] = 0 if item_hash[id].nil?
      item_hash[id.to_s] +=  unit_by_quantity if multiplier
      item_hash[id.to_s] += (invoice_item.quantity) if !multiplier
      item_hash
    end
  end

  def best_item_for_merchant(merchant_id)
    paid_invoice_items = find_invoice_items(merchant_id)
    item_id_and_value = item_id_with_count(paid_invoice_items, "multiplier")
    item_id = group(item_id_and_value)[1].to_i
    items.find_by_id(item_id)
  end

end
