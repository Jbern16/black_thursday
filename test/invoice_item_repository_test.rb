require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'bigdecimal'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/invoice_item'


class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :invoice_item_repo
              :invoice_item

  def setup
    @invoice_item_repo = InvoiceItemRepository.new
    @invoice_items = invoice_item_repo.invoice_items =

                  [InvoiceItem.new({
                     id: 5,
                     item_id: 5,
                     invoice_id: 6,
                     quantity: 50,
                     created_at: "1995-03-18 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC",
                     unit_price: BigDecimal.new("2000")
                    }),
                  InvoiceItem.new({
                     id: 5,
                     item_id: 5,
                     invoice_id: 3,
                     quantity: 50,
                     created_at: "1995-03-20 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC",
                     unit_price: BigDecimal.new("2000")
                    })]
  end

  def test_to_csv
    ir = InvoiceItemRepository.new
    ir.from_csv("./data/invoice_items.csv")
    invoice = ir.find_by_id(6)

    assert_equal 6, invoice.id
  end

  def test_invoice_item_repository_initalizes_with_invoice_items
    assert_equal 2, invoice_item_repo.invoice_items.length
  end

  def test_all_method_returns_all_invoices
    assert_equal 2, invoice_item_repo.all.length
  end

  def test_find_by_id_returns_single_invoice_item_with_matching_id
    assert_equal 5, invoice_item_repo.find_by_id(5).id
  end

  def test_find_all_by_item_id_returns_single_invoice_item_with_matching_id
    assert_equal 2, invoice_item_repo.find_all_by_item_id(5).length
  end

  def test_find_all_by_invoice_id_returns_single_invoice_item_with_matching_id
    assert_equal 1, invoice_item_repo.find_all_by_invoice_id(3).length
  end


end
