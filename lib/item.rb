require 'csv'
require 'pry'
require 'time'
require 'bigdecimal'

class Item

  attr_reader :id, :name, :description, :merchant_objects,
              :unit_price, :merchant_id


  def initialize(data, merchant_objects=nil)
    @id = data[:id]
    @name = data[:name]
    @description = data[:description]
    @unit_price = BigDecimal.new(data[:unit_price])
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @merchant_id = data[:merchant_id]
    unless merchant_objects.nil?
      @merchant_objects = merchant_objects.merchants
    end
  end

  def unit_price_to_dollars
    unit_price_as_dollars = @unit_price / 100
    sprintf('%.2f', unit_price_as_dollars)
  end

  def merchant
    merchant_objects.merchants.find do |merchant|
      merchant.id == merchant_id
    end
  end

  def created_at
    Time.parse(@created_at)
  end

  def updated_at
    Time.parse(@updated_at)
  end

end
