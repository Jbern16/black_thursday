require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'pry'
require 'bigdecimal'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test
      attr_reader :invoices, :invoice_repo

  def setup

    @invoice_repo = InvoiceRepository.new
    @invoices = invoice_repo.invoices = [Invoice.new({
                    id: 5,
                    unit_price: BigDecimal.new(1000),
                    created_at:  "1995-03-18 10:02:43 UTC",
                    updated_at:  "1995-03-23 10:02:43 UTC",
                    customer_id: 1555,
                    merchant_id: 1222,
                    status: "pending"
                   }),
                   Invoice.new({
                    id: 1,
                    unit_price: BigDecimal.new(1000),
                    created_at:  "1995-03-19 10:02:43 UTC",
                    updated_at:  "1995-03-22 10:02:43 UTC",
                    customer_id: 1555,
                    merchant_id: 1222,
                    status: "shipped"
                    })]
  end

  def test_average_invoices_per_day
    assert_equal 0.29, invoice_repo.average_invoices_per_day
  end

  def test_invoice_repository_exists
    assert InvoiceRepository.new
  end

  def test_all_returns_array_of_all_invoices
    assert invoice_repo.all
  end

  def test_find_by_id_finds_invoice_with_inputed_id
    assert_equal 1222, invoice_repo.find_by_id("5").merchant_id
  end

  def test_find_by_id_returns_nil_if_not_a_match
    assert_equal nil, invoice_repo.find_by_id("8")
  end

  def test_find_all_customer_id_finds_all_invoices_by_customer_id
    assert_equal 2, invoice_repo.find_all_by_customer_id(1555).length
  end

  def test_find_all_by_customer_id_returns_empty_array_if_not_found
    assert_equal [], invoice_repo.find_all_by_merchant_id(1242)
  end

  def test_find_all_by_merchant_id_finds_all_matching_invoices
    assert_equal 2, invoice_repo.find_all_by_merchant_id(1222).length
  end

  def test_find_all_by_merchant_id_returns_empty_array_if_not_found
    assert_equal [], invoice_repo.find_all_by_merchant_id(1242)
  end

  def test_find_all_by_status_finds_all_matching_invoices_by_status
    assert_equal 1, invoice_repo.find_all_by_status(:pending).length
  end

  def test_find_all_by_status_returns_empty_array_if_not_found
    assert_equal [], invoice_repo.find_all_by_status(:returned)
  end

  def test_average_invoices_per_day
    assert_equal 0.29, invoice_repo.average_invoices_per_day
  end

  def test_standard_deviation_of_days
   assert_equal 1.0, invoice_repo.standard_deviation_of_days
  end

end
