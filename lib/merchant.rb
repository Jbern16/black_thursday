require 'csv'
require 'pry'

class Merchant
  attr_reader :id,
              :name
  attr_accessor :items

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
    @items = []
    # @items_objects = items_objects.items
  end

  #  def items
  # #   items_objects.items.find do |merchant|
  # #     merchant.id == id
  # #   end
  # # end

end
