require 'csv'
require 'pry'
require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine
  
  attr_reader :items, :merchants

  def self.from_csv(data)
    @merchants = MerchantRepository.new(data[:merchants])
    @items = ItemRepository.new(data[:items])

    SalesEngine
  end

  def self.items
    @items
  end

  def self.merchants
    @merchants
  end
end
