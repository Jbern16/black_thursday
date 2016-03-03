require 'pry'
require_relative 'csv_loader'

class ItemRepository
  attr_accessor :items

  include CsvLoader

  def initialize(file_path=nil)
    unless file_path.nil?
      @items = load(file_path).map { |item| Item.new(item)}
    end
  end

  def all
    items
  end

  def find_by_id(item_id)
    items.find do |item|
      item.id == item_id
    end
  end

  def find_by_name(name_of_item)
    items.find do |item|
      item.name.downcase == name_of_item.downcase
    end
  end

  def find_all_with_description(description_fragment)
    items.select do |item|
      item.description.downcase.include?(description_fragment.downcase)
    end
  end

  def find_all_by_price(price)
    items.select do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(price_range)
    items.select do |item|
      item.unit_price.to_i >= price_range.to_a.first && item.unit_price.to_i <= price_range.to_a.last
    end
  end

  def find_all_by_merchant_id(merchant_id)
    items.select do |item|
      item.merchant_id == merchant_id
    end
  end

end
