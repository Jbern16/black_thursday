require 'csv'
require 'pry'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'

class SalesEngine
  attr_reader :items, :merchants, :invoices

  def initialize(merchants, items, invoices=nil)
    @merchants = merchants
    @items = items
    @invoices = invoices
  end

  def self.from_csv(data)
    merchants = MerchantRepository.new(data[:merchants])
    items = ItemRepository.new(data[:items])
    invoices = InvoiceRepository.new(data[:invoices])

    inject_repos(merchants,items)

    SalesEngine.new(merchants, items, invoices)
  end

  def self.inject_repos(merchants,items)
    give_item_its_merchant(merchants , items)
    give_merchant_its_items(merchants, items)
  end

  def self.give_item_its_merchant(merchants, items)
    items.all.each do |item|
      item.merchant = merchants.find_by_id(item.merchant_id)
    end
  end

  def self.give_merchant_its_items(merchants, items)
    merchants.all.each do |merchant|
      merchant.items = items.find_all_by_merchant_id(merchant.id)
    end
  end

end
