require 'csv'
require 'pry'

class SalesEngine
    attr_reader :items,
                :merchants
  def initialize
    @items = ItemRepository.new
    @merchants = MerchantRepository.new
  end

  def self.from_csv(data_hash)
  end

  def load(data_hash)
    # CSV.open(data_hash[:items], headers: true, header_converters: :symbol)
  end
end
