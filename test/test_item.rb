require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require 'pry'
require 'bigdecimal'
require_relative '../lib/item'


class ItemTest < Minitest::Test
  attr_reader :time, :item

  def setup
    @time = Time.now
    @item = Item.new({
                     id: 5,
                     name: "Pencil",
                     description: "You can use it to write things",
                     unit_price: BigDecimal.new(10.99,4),
                     created_at: time,
                     updated_at: time,
                     merchant_id: 1222
                    })

  end

  def test_id_returns_the_id_of_the_item
    assert_equal 5, item.id
  end

  def test_name_returns_items_name
    assert_equal "Pencil", item.name
  end

  def test_description_returns_items_description
    assert_equal "You can use it to write things", item.description
  end

  def test_unit_price_returns_items_price
    assert_equal BigDecimal.new(10.99,4), item.unit_price
  end

  def test_created_at_returns_time_item_was_created
    assert_equal time, item.created_at
  end

  def test_updated_at_returns_time_item_was_updated
    assert_equal time, item.updated_at
  end

  def test_merchant_id_returns_the_merchant_of_item_id
    assert_equal 1222, item.merchant_id
  end

  def test_unit_price_in_dollars_returns_price_of_item_as_float
    assert_equal 10.99, item.unit_price_to_dollars
  end

end
