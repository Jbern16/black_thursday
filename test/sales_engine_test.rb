require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test

  def test_if_sales_engine_exists
    assert SalesEngine.new("green", "one", "in")
  end

  def test_from_csv_creates_item_and_merchant_repository
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
      # :transactions => "./data/transactions.csv",
      # :customers => "./data/customers.csv"
      })

    assert se.merchants
    assert se.items
    assert se.invoices
    assert se.invoice_items
    # assert se.transactions
    # assert se.customers
    invoice = se.invoices.find_by_id(18)
    assert_equal 7, invoice.items.length
  end

#   def test_from_csv_method_when_used_on_an_instance_of_sales_engine
#     se = SalesEngine.from_csv({
#           :items     => "./data/items.csv",
#           :merchants => "./data/merchants.csv"
#           # :invoices
#         })
#
#     merchant = se.merchants.find_by_id(12334105)
#     assert_equal "Vogue Paris Original Givenchy 2307", merchant.items[0].name
#
#     item = se.items.find_by_id(263395237)
#     assert_equal "jejum", item.merchant.name
#   end
#
#   def test_from
#     se = SalesEngine.from_csv({
#       :items => "./data/items.csv",
#       :merchants => "./data/merchants.csv",
#       :invoices => "./data/invoices.csv"
#         })
#
#         merchant = se.merchants.find_by_id(12334105)
#         merchant.invoices
#
#         invoice = se.invoices.find_by_id(20)
#         invoice.merchant
#   end
end
