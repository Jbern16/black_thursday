require 'pry'
require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine

  attr_reader :items, :merchants

  def initialize(merchants, items)
    @merchants = merchants
    @items = items
    # give_item_its_merchant
    # give_merchant_its_items
  end

  def give_item_its_merchant
  end

  # from_csv --> "factory method"
  # method on the class designed to assist with the construction of
  # new instances

  def self.from_csv(data)
    merchants = MerchantRepository.new(data[:merchants])
    items = ItemRepository.new(data[:items])
    give_item_its_merchant(merchants , items)
    give_merchant_its_items(merchants, items)


    se = SalesEngine.new(merchants, items)
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
