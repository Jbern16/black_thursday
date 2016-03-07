require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test

  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/fake_items.csv",
      :merchants => "./data/fake_merchants.csv",
      :invoices => "./data/fake_invoices.csv",
      :invoice_items => "./data/fake_invoice_items.csv",
      :transactions => "./data/fake_transactions.csv",
      :customers => "./data/fake_customer.csv"
      })
  end

  def test_from_csv_creates_merchants_repository
    assert_equal MerchantRepository, se.merchants.class
  end

  def test_from_csv_creates_items_repository
    assert_equal ItemRepository, se.items.class
  end

  def test_from_csv_creates_invoices_repository
    assert_equal InvoiceRepository, se.invoices.class
  end

  def test_from_csv_creates_invoice_items_repository
    assert_equal InvoiceItemRepository, se.invoice_items.class
  end

  def test_from_csv_creates_transactions_repository
    assert_equal TransactionRepository, se.transactions.class
  end

  def test_from_csv_creates_customers_repository
    assert_equal CustomerRepository, se.customers.class
  end

  def test_item_has_merchant
    item = se.items.find_by_id(3)
    assert_equal "merchant3", item.merchant.name
  end

  def test_merchant_has_items
    merchant = se.merchants.find_by_id(1)
    assert_equal "item1", merchant.items[0].name
  end

  def test_invoice_has_merchants
    invoice = se.invoices.find_by_id(3)
    assert_equal "merchant3", invoice.merchant.name
  end

  def test_merchant_has_invoices
    merchant = se.merchants.find_by_id(5)
    assert_equal 2, merchant.invoices.length
  end

  def test_invoice_has_items
    invoice = se.invoices.find_by_id(1)
    assert_equal 5, invoice.items.length
  end

  def test_invoice_has_transactions
    invoice = se.invoices.find_by_id(3)
    assert_equal 2, invoice.transactions.length
  end

  def test_invoice_has_customer
    invoice = se.invoices.find_by_id(2)
    assert_equal "Cecelia", invoice.customer.first_name
  end

  def test_transaction_has_invoice
   transactions = se.transactions.find_by_id(2)
   assert_equal 2, transactions.invoice.id
  end

  def test_merchant_has_customers
    merchant = se.merchants.find_by_id(4)
    assert_equal 1, merchant.customers.length
  end

  def test_customer_has_merchants
    customer = se.customers.find_by_id(5)
    assert_equal 2, customer.merchants.length
  end

end
