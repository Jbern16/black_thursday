require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test

  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
      })
  end

  def test_if_sales_engine_exists
    skip
    assert SalesEngine.new("green", "one", "in")
  end

  def test_from_csv_creates_repositories

    assert se.merchants
    assert se.items
    assert se.invoices
    assert se.invoice_items
    assert se.transactions
    assert se.customers
  end

  def test_items_have_merchants_and_merchants_have_items
    merchant = se.merchants.find_by_id(12334105)
    assert_equal "Vogue Paris Original Givenchy 2307", merchant.items[0].name

    item = se.items.find_by_id(263395237)
    assert_equal "jejum", item.merchant.name
  end

  def test_invoices_have_merchants
    merchant = se.merchants.find_by_id(12334105)
    merchant.invoices

    invoice = se.invoices.find_by_id(20)
    invoice.merchant
  end

  def test_invoices_have_items
    invoice = se.invoices.find_by_id(18)

    assert_equal 7, invoice.items.length
  end

  def test_invoice_has_transactions
    invoice = se.invoices.find_by_id(18)
    assert_equal 2, invoice.transactions.length
  end

  def test_invoice_has_customers
    invoice = se.invoices.find_by_id(18)
    assert_equal 2, invoice.customers
  end

  def transactions_has_its_invoices
   transactions = se.transactions.find_all_by_id(40)
   assert_equal [], transactions.invoice.length
  end

  def merchant_has_customers
    merchant = se.merchants.find_all_by_id(10)
     assert_equal [], merchant.customers.length
  end

  def customer_has_merchants
    customer = se.customers.find_by_id(30)
    assert_equal [], customer.merchants.length
  end

end
