require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require_relative '../lib/sales_analyst'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'


class SalesAnalystTest < Minitest::Test
  attr_reader :merchants, :items, :se, :mr, :ir, :invoice_repo, :invoices

  def setup
    time = Time.now

    @mr = MerchantRepository.new
    @merchants = mr.merchants =
                  [Merchant.new({id: 5, name: "Turing School"}),
                  Merchant.new({id: 7, name: "Tom School"}),
                  Merchant.new({id: 9, name: "CoolDecor"})]


    @ir = ItemRepository.new
    @items = ir.items =
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
                  id: 6,
                  name: "Stupid Expensive Pen",
                  description: "You can use it to write things like a cheap pen",
                  unit_price: BigDecimal("5000"),
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
                   name: "Eraser",
                   description: "You can use it to erase things",
                   unit_price: BigDecimal("1100"),
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
                   unit_price: BigDecimal("1100"),
                   created_at: time,
                   updated_at: time,
                   merchant_id: 7})]

    @invoice_repo = InvoiceRepository.new
    @invoices = invoice_repo.invoices =
                    [Invoice.new({
                     id: 5,
                     unit_price: BigDecimal.new(1000),
                     created_at: Time.parse("1995-03-19 10:02:43 UTC"),
                     updated_at: time,
                     customer_id: 1555,
                     merchant_id: 7,
                     status: "pending"
                    }),
                    Invoice.new({
                     id: 1,
                     unit_price: BigDecimal.new(1000),
                     created_at: Time.parse("1995-03-20 10:02:43 UTC"),
                     updated_at: time,
                     customer_id: 1555,
                     merchant_id: 7,
                     status: "shipped"
                     }),
                     Invoice.new({
                      id: 3,
                      unit_price: BigDecimal.new(1000),
                      created_at: Time.parse("1995-03-18 10:02:43 UTC"),
                      updated_at: time,
                      customer_id: 1555,
                      merchant_id: 5,
                      status: "shipped"})]


    @se = SalesEngine.new(mr, ir, invoice_repo)

    se.items.all.map do |item|
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

    se.invoices.all.map do |invoice|
      this = merchants.find do |merchant|
        invoice.merchant_id == merchant.id
      end
      invoice.merchant = this
    end

    se.merchants.all.map do |merchant|
      this = invoices.select do |invoice|
        merchant.id == invoice.merchant_id
      end
      merchant.invoices = this
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

    assert_equal 2.33, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation_returns
    sa = SalesAnalyst.new(se)
    assert_equal 3.21, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count_returns_array_of_merchants_up_one_from_standard_dev
    sa = SalesAnalyst.new(se)
    assert_equal "Turing School", sa.merchants_with_high_item_count[0].name
  end

  def test_average_item_price_for_merchant_returns_avg_price
    sa = SalesAnalyst.new(se)
    assert_equal 22.67, sa.average_item_price_for_merchant(5).to_f
  end

  def test_standard_deviation_for_unit_price
    sa = SalesAnalyst.new(se)
    assert_equal 13.72, sa.standard_deviation_for_unit_price
  end

  def test_golden_items_returns_items_with_unit_price_two_over_mean_unit_price
    sa = SalesAnalyst.new(se)
    assert_equal "Stupid Expensive Pen", sa.golden_items[0].name
  end

  def test_finding_average_average_price_per_merchant
    sa = SalesAnalyst.new(se)
    price = 11
    assert_equal price, sa.average_average_price_per_merchant.floor
  end

  def test_average_invoices_per_merchant
    sa = SalesAnalyst.new(se)
    assert_equal 1.0, sa.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    sa = SalesAnalyst.new(se)
    assert_equal 1, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_bottom_merchants_by_invoice_count
    sa = SalesAnalyst.new(se)
    assert_equal [], sa.bottom_merchants_by_invoice_count
  end

  def test_top_merchants_by_invoice_count_returns_array_of_merchants_with_most_invoices
    sa = SalesAnalyst.new(se)
    assert_equal [], sa.top_merchants_by_invoice_count
  end

  def test_top_days_by_invoice_count_returns_array_with_days_containing_most_invoices
    sa = SalesAnalyst.new(se)
    assert_equal [], sa.top_days_by_invoice_count
  end

  def test_invoice_status_returns_percentage
    sa = SalesAnalyst.new(se)
    assert_equal 33.0, sa.invoice_status(:pending)
  end
end
