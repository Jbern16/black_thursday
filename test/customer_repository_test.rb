require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require_relative '../lib/customer_repository'
require_relative '../lib/customer'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo
              :customers

  def setup
    @customer_repo = CustomerRepository.new
    @customers = customer_repo.customers =

                  [Customer.new({
                     id: 5,
                     first_name: "ali",
                     last_name: "smith",
                     created_at: "1995-03-18 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC",
                    }),
                  Customer.new({
                     id: 5,
                     first_name: "jim",
                     last_name: "smith",
                     created_at: "1995-03-20 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC",
                    })]
  end

  def test_t
    cr = CustomerRepository.new
    cr.from_csv("./data/customers.csv")
    customer = cr.find_by_id(6)

    assert_equal "Heber", customer.first_name
  end

  def test_invoice_item_repository_initalizes_with_invoice_items
    assert_equal 2, customer_repo.customers.length
  end

  def test_all_method_returns_all_invoices
    assert_equal 2, customer_repo.all.length
  end

  def test_find_by_id_returns_single_invoice_item_with_matching_id
    assert_equal "ali", customer_repo.find_by_id(5).first_name
  end

  def test_find_all_by_item_id_returns_single_invoice_item_with_matching_id
    assert_equal 1, customer_repo.find_all_by_first_name("ali").length
  end

  def test_find_all_by_invoice_id_returns_single_invoice_item_with_matching_id
    assert_equal 2, customer_repo.find_all_by_last_name("smith").length
  end


end
