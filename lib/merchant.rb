require 'csv'
require 'pry'

class Merchant
  attr_reader :id, :items_repo,
              :name

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
    @items_repo = nil
    # @items_objects = items_objects.items
  end

  #  def items
  # #   items_objects.items.find do |merchant|
  # #     merchant.id == id
  # #   end
  # # end

end
