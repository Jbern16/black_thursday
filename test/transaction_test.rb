require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require_relative '../lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :transaction

  def setup
     @transaction = Transaction.new({
                     id: 5,
                     invoice_id: 6,
                     credit_card_number: 12220303,
                     credit_card_expiration_date: 0517,
                     result: 'success',
                     created_at: "1995-03-18 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC",})
  end

  def test_transaction_is_initialized_with_proper_attributes
    assert transaction.id
    assert transaction.invoice_id
    assert transaction.credit_card_number
    assert transaction.credit_card_expiration_date
    assert transaction.result
    assert transaction.created_at
    assert transaction.updated_at
  end





  end
