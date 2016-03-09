require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'pry'
require 'ostruct'
require_relative '../lib/invoice'
require_relative '../lib/transaction'
require_relative '../lib/invoice_item'


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
      merchant_id: 10 }

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

  def test_invoice_is_paid_in_full
    transaction = OpenStruct.new(result: "success")
    transactions = [transaction]
    invoice.transactions = transactions

    assert_equal true, invoice.is_paid_in_full?
  end

  def test_invoice_is_paid_in_full_returns_false_if_result_is_failed
    transaction = OpenStruct.new(result: "failed")
    transactions = [transaction]
    invoice.transactions = transactions

    assert_equal false, invoice.is_paid_in_full?
  end

  def test_invoice_total
    transaction = OpenStruct.new(result: "success")
    transactions = [transaction]
    invoice.transactions = transactions

    invoice_item = OpenStruct.new(quantity: 50, unit_price: 10 )
    invoice_items = [invoice_item]
    invoice.invoice_items = invoice_items

    assert_equal 500, invoice.total
  end

  def test_if_invoice_isnt_paid_in_full_total_isnt_returned
    transaction = OpenStruct.new(result: "failed")
    transactions = [transaction]
    invoice.transactions = transactions

    invoice_item = OpenStruct.new(quantity: 50, unit_price: 10 )
    invoice_items = [invoice_item]
    invoice.invoice_items = invoice_items

    assert_equal nil, invoice.total
  end

end
