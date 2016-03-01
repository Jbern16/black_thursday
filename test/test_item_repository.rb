require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'


class ItemRepositoryTest < Minitest::Test
  attr_reader :ir

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      })
    @ir = se.items
  end

  def test_all_method_returns_all_know_items_in_an_array
    items = ir.all
    assert_equal 1367, items.length
  end

  def test_find_by_id_method_finds_one_instance_matching_id_of_item
    item = ir.find_by_id("263567474")
    assert_equal "Minty Green Knit Crochet Infinity Scarf", item[:name]
  end

  def test_find_by_id_method_returns_nil_if_no_matching_id
    item = ir.find_by_id("999999999")
    assert_equal nil, item
  end

  def test_find_by_name_method_finds_one_instance_matching_name_of_item
    item = ir.find_by_name("Minty Green Knit Crochet Infinity Scarf")
    assert_equal "263567474", item[:id]
  end

  def test_find_by_name_method_returns_nil_if_no_matching_name
    item = ir.find_by_name("This is a fake name")
    assert_equal nil, item
  end

  def test_find_by_name_method_finds_one_instance_matching_name_of_item_even_with_wrong_case
    item = ir.find_by_name("Minty grEEn KNit crOChet Infinity Scarf")
    assert_equal "263567474", item[:id]
  end

  def test_find_all_with_description_returns_array_containing_all_matches_with_included_description
    fragment = "Thank you for your cooperation"
    items = ir.find_all_with_description(fragment)
    assert_equal 3, items.length

    answer1 = "Tea Party Teapot & Teacup Cupcake Wrappers ~ Party Favor ~ 1 Dozen"
    answer2 = "Castle Theme Party - Dragon, Knight, Princess ~  Cupcake Wrappers ~ Set of 1 Dozen"

    assert_equal answer1, items.first[:name]
    assert_equal answer2, items.last[:name]
  end

  def test_find_all_by_price_returns_all_matching_price_given
    items = ir.find_all_by_price("100")
    assert_equal 4, items.length
    assert_equal "SALE Rudolf Reindeer Dummy Clip", items.first[:name]
  end

end
