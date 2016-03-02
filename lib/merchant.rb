require 'csv'
require 'pry'

class Merchant
  attr_reader :id,
              :name

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
  end

  # def items
  #   items = ItemRepository.new("./data/items.csv")
  #   this = items.items.find do |item|
  #     item.merchant_id == id
  #   end
  end

end
