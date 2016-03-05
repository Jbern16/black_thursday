require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require_relative '../lib/customer_repository'
require_relative '../lib/customer'


class CustomerTest < Minitest::Test
  attr_reader :customer

  def setup
     @customer = Customer.new({
                     id: 5,
                     first_name: "Jon",
                     last_name: "B",
                     created_at: "1995-03-18 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC"})
  end

  def test_invoice_is_initialized_with_proper_attributes
    assert customer.id
    assert customer.first_name
    assert customer.last_name
    assert customer.created_at
    assert customer.updated_at
  end

end
