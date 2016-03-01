require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :mr

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      })

    @mr = se.merchants
  end

  def test_all_method_returns_array
    merchant = mr.all

    assert_equal Array, merchant.class
  end

  def test_find_by_id_method_returns_merchant_with_matching_id
    answer = "Shopin1901"
    merchant = mr.find_by_id("12334105")

    assert_equal answer, merchant[:name]
  end

  def test_find_by_id_method_returns_nil_if_doesnt_match_merchants
    answer = nil
    merchant = mr.find_by_id("999999999")

    assert_equal answer, merchant
  end

  def test_find_by_name_method_returns_merchant_with_matching_name
    answer = "12334105"
    merchant = mr.find_by_name("Shopin1901")

    assert_equal answer, merchant[:id]
  end

  def test_find_by_name_method_returns_merchant_with_matching_name_even_if_case_is_off
    answer = "12334105"
    merchant = mr.find_by_name("SHOPin1901")

    assert_equal answer, merchant[:id]
  end

  def test_find_by_name_method_returns_nil_if_doesnt_match_merchants
    answer = nil
    merchant = mr.find_by_name("Snot Catcher")

    assert_equal answer, merchant
  end

  def test_find_all_by_name_method_returns_array_of_matching_merchants
    answer = "[#<CSV::Row id:\"12336642\" name:\"southernncreations\" created_at:\"2006-10-24\" updated_at:\"2015-04-03\">, #<CSV::Row id:\"12336889\" name:\"SouthernComfrtCndles\" created_at:\"2003-09-27\" updated_at:\"2004-06-30\">]"
    merchant = mr.find_all_by_name("ouThe")

    assert_equal answer, merchant.to_s
  end

end
