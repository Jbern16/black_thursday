require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require 'pry'
require_relative '../lib/item_repository'
require_relative '../lib/item'


class ItemRepositoryTest < Minitest::Test
  attr_reader :ir
              :items

  def setup
    time = Time.now
    @ir = ItemRepository.new
    @items = ir.items = [Item.new({
                     id: 5,
                     name: "Pencil",
                     description: "You can use it to write things",
                     unit_price: 1000,
                     created_at: time,
                     updated_at: time,
                     merchant_id: 1222
                    }),
                    Item.new({
                     id: 1,
                     name: "Eraser",
                     description: "You can use it to erase things",
                     unit_price: 1050,
                     created_at: time,
                     updated_at: time,
                     merchant_id: 1255
                    })]

  end

  def test_all_method_returns_all_know_items_in_an_array
    items = ir.all

    assert_equal 2, items.length
  end

  def test_find_by_id_method_finds_one_instance_matching_id_of_item
    item = ir.find_by_id(1)

    assert_equal "Eraser", item.name
  end

  def test_find_by_id_method_returns_nil_if_no_matching_id
    item = ir.find_by_id("9999999")

    assert_equal nil, item
  end

  def test_find_by_name_method_finds_one_instance_matching_name_of_item
    item = ir.find_by_name("Eraser")

    assert_equal 1, item.id
  end

  def test_find_by_name_method_returns_nil_if_no_matching_name
    item = ir.find_by_name("This is a fake name")

    assert_equal nil, item #fix
  end

  def test_find_by_name_method_finds_one_instance_matching_name_of_item_even_with_wrong_case
    item = ir.find_by_name("ERAser")

    assert_equal 1, item.id
  end

  def test_find_all_with_description_returns_array_containing_all_matches_with_included_description
    fragment = "can use"
    items = ir.find_all_with_description(fragment)

    answer1 = "Pencil"
    answer2 = "Eraser"

    assert_equal 2, items.length
    assert_equal answer1, items.first.name
    assert_equal answer2, items.last.name
  end

  def test_find_all_by_price_returns_all_matching_price_given
    items = ir.find_all_by_price(1000)

    assert_equal "Pencil", items.first.name
  end

  def test_find_all_by_price_returns_all_matching_price_range_given
    items = ir.find_all_by_price_in_range(1000..1100)
    ir.merchants
    assert_equal 2, items.length
    assert_equal "Pencil", items.first.name
    assert_equal "Eraser", items.last.name
  end

  def test_find_all_by_merchant_id_returns_all_matching_merchant_id
    items = ir.find_all_by_merchant_id(1222)

    assert_equal "Pencil", items.first.name
  end

end
