require 'csv'
require 'pry'
require 'bigdecimal'

class Item
  attr_reader :id, :name, :description,
              :unit_price, :updated_at,
              :created_at, :merchant_id

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
    @description = data[:description]
    @unit_price = data[:unit_price]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @merchant_id = data[:merchant_id]
  end

  def unit_price_to_dollars
    unit_price.to_f
  end

  def merchant
    merchant = MerchantRepository.new("./data/merchants.csv")
    merchant.merchants.find do |merchant|
      merchant.id == merchant_id
    end
  end

end
