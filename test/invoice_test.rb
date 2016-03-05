require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'pry'
require_relative '../lib/invoice'


class InvoiceTest < Minitest::Test
  attr_reader :invoice, :data

  def setup

    @data = {
      id: 12221,
      unit_price: 100,
      created_at: "1995-03-19 10:02:43 UTC",
      updated_at: "1995-03-20 10:02:43 UTC",
      customer_id: 15,
      status: "pending",
      merchant_id: 10}
    @invoice = Invoice.new(data)

  end

  def test_invoice_exists
    assert Invoice.new(data)
  end

  def test_invoice_has_attributes
    assert invoice.id
    assert invoice.customer_id
    assert invoice.merchant_id
    assert invoice.status
    assert invoice.created_at
    assert invoice.updated_at
  end

end
