require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant'
require "ostruct"

class MerchantTest < Minitest::Test
  attr_reader :merchant

  def setup
    @merchant = Merchant.new({id: 5,
                              name: "Turing School",
                              items: []
                             })
  end

  def test_marchant_is_created_with_an_id
    assert_equal 5, merchant.id
  end

  def test_marchant_is_created_with_a_name
    assert_equal "Turing School", merchant.name
  end

  def test_merchant_has_items
    merchant.items = ["pencil", "pen"]
    assert_equal ["pencil", "pen"], merchant.items
  end

  def test_average_item_price
    i1 = OpenStruct.new({unit_price: 10})
    i2 = OpenStruct.new({unit_price: 20})
    merchant.items = [i1,i2]
    assert_equal 15, merchant.average_item_price
  end

  def test_average_item_price_is_zero_when_no_items
    assert_equal 0, merchant.average_item_price
  end

end
