require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require 'pry'
require 'bigdecimal'
require_relative '../lib/item'


class ItemTest < Minitest::Test

  def test_item_is_intialized_with_proper_values
    time = Time.now
    item = Item.new({
                     id: 5,
                     name: "Pencil",
                     description: "You can use it to write things",
                     unit_price: BigDecimal.new(10.99,4),
                     created_at: time,
                     updated_at: time,
                     merchant_id: 1222
                    })

    assert_equal 5, item.id
    assert_equal "Pencil", item.name
    assert_equal "You can use it to write things", item.description
    assert_equal BigDecimal.new(10.99,4), item.unit_price
    assert_equal time, item.created_at
    assert_equal time, item.updated_at
    assert_equal 1222, item.merchant_id
  end

  def test_unit_price_in_dollars_returns_price_of_item_as_float
    item = Item.new({
                     id: 5,
                     name: "Pencil",
                     description: "You can use it to write things",
                     unit_price: BigDecimal.new(10.99,4),
                     created_at: time,
                     updated_at: time,
                     merchant_id: 1222
                    })

    assert_equal 10.99, item.unit_price_to_dollars
  end





end
