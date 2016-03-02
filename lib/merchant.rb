require 'csv'
require 'pry'

class Merchant
  attr_reader :id, :items_objects,
              :name

  def initialize(data)#, items_objects=nil)
    @id = data[:id]
    @name = data[:name]
    # @items_objects = items_objects.items
  end

  # def items
  #   items_objects.items.find do |merchant|
  #     merchant.id == id
  #   end
  # end

end
