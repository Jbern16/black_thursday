require 'csv'
require 'pry'
require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine
  attr_reader :items, :merchants

  def self.from_csv(data_hash)
    @items = MerchantRepository.new(data_hash[:merchants])
    @merchants = ItemRepository.new(data_hash[:items])

    SalesEngine
  end

  def self.items
    @items
  end

  def self.merchants
    @merchants
  end
end
