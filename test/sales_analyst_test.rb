require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require_relative '../lib/sales_analyst'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item'


class SalesAnalystTest < Minitest::Test
  attr_reader :merchants, :items, :se, :mr

  def setup
    time = Time.now

    @mr = MerchantRepository.new
    @merchants = mr.merchants =
                  [Merchant.new({id: 5, name: "Turing School"}),
                  Merchant.new({id: 7, name: "Tom School"}),
                  Merchant.new({id: 9, name: "CoolDecor"})]

    @items = ItemRepository.new.items =
    [Item.new({
    id: 4,
    name: "Pencil",
    description: "You can use it to write things",
    unit_price: BigDecimal("2500"),
    created_at: time,
    updated_at: time,
    merchant_id: 5}),

    Item.new({
    id: 6,
    name: "Pens",
    description: "You can use it to write things",
    unit_price: BigDecimal("2000"),
    created_at: time,
    updated_at: time,
    merchant_id: 5}),

   Item.new({
    id: 1,
    name: "Eraser",
    description: "You can use it to erase things",
    unit_price: BigDecimal("1500"),
    created_at: time,
    updated_at: time,
    merchant_id: 5}),

    Item.new({
     id: 1,
     name: "Tweesers",
     description: "You can use it to pluck things",
     unit_price: BigDecimal("2000"),
     created_at: time,
     updated_at: time,
     merchant_id: 7})]

    @se = SalesEngine.new(mr, items)

    se.items.map do |item|
      this = merchants.find do |merchant|
        merchant.id == item.merchant_id
      end
      item.merchant = this
    end

    se.merchants.all.map do |merchant|
      this = items.select do |item|
        item.merchant_id == merchant.id
      end
      merchant.items = this
    end

  end

  def test_sales_analyst_is_initialized_with_sales_engine
    sa = SalesAnalyst.new(se)
    assert sa
  end

  def test_sales_analyst_has_acces_to_merchants_and_items
    sa = SalesAnalyst.new(se)

    assert sa.items
    assert sa.merchants
  end

  def test_average_items_per_merchant_returns_avg
    sa = SalesAnalyst.new(se)

    assert_equal 1.0, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation_returns
    sa = SalesAnalyst.new(se)
    assert_equal 1.58, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count_returns_array_of_merchants_up_one_from_standard_dev
    sa = SalesAnalyst.new(se)
    assert_equal "Turing School", sa.merchants_with_high_item_count[0].name
  end

  def test_average_item_price_for_merchant_returns_avg_price
    sa = SalesAnalyst.new(se)
    assert_equal BigDecimal(2000), sa.average_item_price_for_merchant(5)
  end

end
