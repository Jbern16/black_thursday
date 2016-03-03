require 'csv'
require 'pry'
require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine

  attr_reader :items, :merchants

  def initialize(merchants, items)
    @merchants = merchants
    @items = items
  end

  def self.from_csv(data)
    merchants = MerchantRepository.new(data[:merchants])
    items = ItemRepository.new(data[:items])
    inject_repo(merchants, items)

    SalesEngine.new(merchants, items)
  end

  def self.inject_repo(merchants, items)
    merchants.items_repo = items
    items.merchant_repo = merchants
  end













end
