require 'pry'

class Merchant
  attr_reader :id,
              :name
  attr_accessor :items, :invoices

  def initialize(data)
    @id = data[:id].to_i
    @name = data[:name]
    @items = []
    @invoices = []
  end

  def average_item_price
    if items.any?
      items.map(&:unit_price).reduce(0,:+) / items.length
    else
      0
    end
  end

end
