require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/invoice_item'

class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item

  def setup
     @invoice_item = InvoiceItem.new({
                     id: 5,
                     item_id: 5,
                     invoice_id: 6,
                     quantity: 50,
                     created_at: "1995-03-18 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC",
                     unit_price: BigDecimal.new("2000")})
  end

  def test_invoice_is_initialized_with_proper_attributes
    assert invoice_item.id
    assert invoice_item.item_id
    assert invoice_item.invoice_id
    assert invoice_item.quantity
    assert invoice_item.created_at
    assert invoice_item.updated_at
    assert invoice_item.unit_price
  end

  def test_unit_price_as_dollars_returns_formatted_num
    assert_equal "20.00", invoice_item.unit_price_to_dollars
  end

  end
