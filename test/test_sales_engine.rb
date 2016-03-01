require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/sales_engine'


class SalesEngineTest < Minitest::Test

  def test_if_sales_engine_exists
    assert SalesEngine.new
  end

  def test_from_csv_creates_item_and_merchant_repository
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv"
      })

    assert se.merchants
    assert se.items
  end

  def test_from_csv_method_when_used_on_an_instance_of_sales_engine
  end

  # def test_all_method_returns_array
  #   se = SalesEngine.from_csv({
  #     :items     => "./data/items.csv",
  #     :merchants => "./data/merchants.csv",
  #     })
  #
  #   mr = se.merchants
  #   merchant = mr.all
  #   assert_equal Array, merchant.class
  # end
  #
  # def test_find_by_id_method_returns_merchant_with_matching_id
  #   se = SalesEngine.from_csv({
  #     :items     => "./data/items.csv",
  #     :merchants => "./data/merchants.csv",
  #     })
  #
  #   answer = "Shopin1901"
  #
  #   mr = se.merchants
  #   merchant = mr.find_by_id("12334105")
  #   assert_equal answer, merchant[:name]
  # end
  #
  # def test_find_by_id_method_returns_nil_if_doesnt_match_merchants
  #   se = SalesEngine.from_csv({
  #     :items     => "./data/items.csv",
  #     :merchants => "./data/merchants.csv",
  #     })
  #
  #   answer = nil
  #
  #   mr = se.merchants
  #   merchant = mr.find_by_id("999999999")
  #   assert_equal answer, merchant
  # end
  #
  # def test_find_by_name_method_returns_merchant_with_matching_name
  #   se = SalesEngine.from_csv({
  #     :items     => "./data/items.csv",
  #     :merchants => "./data/merchants.csv",
  #     })
  #
  #   answer = "12334105"
  #
  #   mr = se.merchants
  #   merchant = mr.find_by_name("Shopin1901")
  #   assert_equal answer, merchant[:id]
  # end
  #
  # def test_find_by_name_method_returns_merchant_with_matching_name_even_if_case_is_off
  #   se = SalesEngine.from_csv({
  #     :items     => "./data/items.csv",
  #     :merchants => "./data/merchants.csv",
  #     })
  #
  #   answer = "12334105"
  #
  #   mr = se.merchants
  #   merchant = mr.find_by_name("SHOPin1901")
  #   assert_equal answer, merchant[:id]
  # end
  #
  # def test_find_by_name_method_returns_nil_if_doesnt_match_merchants
  #   se = SalesEngine.from_csv({
  #     :items     => "./data/items.csv",
  #     :merchants => "./data/merchants.csv",
  #     })
  #
  #   answer = nil
  #
  #   mr = se.merchants
  #   merchant = mr.find_by_name("Snot Catcher")
  #   assert_equal answer, merchant
  # end
  #
  # def test_find_all_by_name_method_returns_array_of_matching_merchants
  #   se = SalesEngine.from_csv({
  #     :items     => "./data/items.csv",
  #     :merchants => "./data/merchants.csv",
  #     })
  #
  #   answer = "[#<CSV::Row id:\"12336642\" name:\"southernncreations\" created_at:\"2006-10-24\" updated_at:\"2015-04-03\">, #<CSV::Row id:\"12336889\" name:\"SouthernComfrtCndles\" created_at:\"2003-09-27\" updated_at:\"2004-06-30\">]"
  #
  #   mr = se.merchants
  #   merchant = mr.find_all_by_name("ouThe")
  #   assert_equal answer, merchant.to_s
  # end



end
