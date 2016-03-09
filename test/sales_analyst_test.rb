require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require 'time'
require_relative '../lib/sales_analyst'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'


class SalesAnalystTest < Minitest::Test
  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/fixture_items.csv",
      :merchants => "./data/fixture_merchants.csv",
      :invoices => "./data/fixture_invoices.csv",
      :invoice_items => "./data/fixture_invoice_items.csv",
      :transactions => "./data/fixture_transactions.csv",
      :customers => "./data/fixture_customer.csv"
    })

    @sa = SalesAnalyst.new(se)

  end

  def test_sales_analyst_is_initialized_with_sales_engine
    assert_equal SalesAnalyst, sa.class
  end

  def test_sales_analyst_has_acces_to_item_repo
    assert_equal ItemRepository, sa.items.class
  end

  def test_sales_analyst_has_acces_to_merchant_repo
    assert_equal MerchantRepository, sa.merchants.class
  end

  def test_sales_analyst_has_acces_to_invoice_repo
    assert_equal InvoiceRepository, sa.invoices.class
  end

  def test_sales_analyst_has_acces_to_invoice_item_repo
    assert_equal InvoiceItemRepository, sa.invoice_items.class
  end

  def test_sales_analyst_has_acces_to_transaction_repo
    assert_equal TransactionRepository, sa.transactions.class
  end

  def test_sales_analyst_has_acces_to_customer_repo
    assert_equal CustomerRepository, sa.customers.class
  end

  def test_average_items_per_merchant_returns_avg
    assert_equal 0.71, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation_returns
    assert_equal 0.95, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count_returns_array_of_merchants_up_one_from_standard_dev
    assert_equal 2, sa.merchants_with_high_item_count.length
  end

  def test_average_item_price_for_merchant_returns_avg_price
    assert_equal 0.0, sa.average_item_price_for_merchant(5)
  end

  def test_average_item_price_for_merchant_returns_avg_price
    assert_equal 25.0, sa.average_item_price_for_merchant(3)
  end

  def test_standard_deviation_for_unit_price
    assert_equal 5.87, sa.standard_deviation_for_unit_price
  end

  def test_golden_items_returns_items_with_unit_price_two_over_mean_unit_price
    assert_equal 0, sa.golden_items.length
  end

  def test_finding_average_average_price_per_merchant
    assert_equal 11, sa.average_average_price_per_merchant.floor
  end

  def test_average_invoices_per_merchant
    sa = SalesAnalyst.new(se)
    assert_equal 5.29, sa.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    sa = SalesAnalyst.new(se)
    assert_equal 1.98, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_bottom_merchants_by_invoice_count
    sa = SalesAnalyst.new(se)
    assert_equal 1, sa.bottom_merchants_by_invoice_count.length
  end

  def test_top_merchants_by_invoice_count_returns_array_of_merchants_with_most_invoices
    sa = SalesAnalyst.new(se)
    assert_equal [], sa.top_merchants_by_invoice_count
  end

  def test_top_days_by_invoice_count_returns_array_with_days_containing_most_invoices
    sa = SalesAnalyst.new(se)
    assert_equal ["Saturday"], sa.top_days_by_invoice_count
  end

  def test_invoice_status_returns_percentage
    sa = SalesAnalyst.new(se)
    assert_equal 8.11, sa.invoice_status(:pending)
  end

  def test_total_revenue_by_date_returns_revenue_for_date
    assert_equal 1080.0, sa.total_revenue_by_date(Time.parse("2009/03/27")).to_f
  end

  def test_total_revenue_by_date_returns_revenue_for_date_that_doesnt_have_revenue
    assert_equal 0.0, sa.total_revenue_by_date(Time.parse("2012/03/26")).to_f
  end

  def test_top_revenue_earners_returns_array_of_top_earners
    assert_equal 3, sa.top_revenue_earners(3).length
  end

  def test_revenue_by_merchant_returns_total_revenue
    assert_equal 15482.0, sa.revenue_by_merchant(2).to_f
  end

  def test_merchants_with_pending_status_returns_any_merchant_with_pending
    assert_equal 6, sa.merchants_with_pending_invoices.length
  end

  def test_merchants_with_only_one_item
    assert_equal 1, sa.merchants_with_only_one_item.length
  end

  def test_merchants_with_only_one_item_registered_in_month_returns_merchants
    assert_equal 1, sa.merchants_with_only_one_item_registered_in_month("March").length
  end

  def test_merchants_ranked_by_revenues_first_merchant_is_highest
    assert_equal 2, sa.merchants_ranked_by_revenue.first.id
  end

  def test_we_find_most_sold_item_for_mercant
    assert_equal 1, sa.most_sold_item_for_merchant(2).length
  end

  def test_we_find_best_item_for_merchant_when_provided_an_id
    assert_equal 2, sa.best_item_for_merchant(2).id
  end


end
