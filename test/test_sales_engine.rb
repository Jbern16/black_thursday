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

end