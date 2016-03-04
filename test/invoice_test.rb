require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'pry'
require_relative '../lib/invoice'


class InvoiceTest < Minitest::Test
  attr_reader :invoice, :data

  def setup
    time = Time.now
    @data = {
      id: 12221,
      unit_price: 100,
      created_at: time,
      updated_at: time,
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
