require 'csv'
require 'pry'
require_relative 'csv_loader'

class ItemRepository
  attr_reader :items
  include CsvLoader

  def initialize(file_path)
    @items = load(file_path).map { |row| row }
  end

  def all
    items
  end

  def find_by_id(item_id)
    items.find do |item|
      item[:id] == item_id
    end
  end

  def find_by_name(name_of_item)
    items.find do |item|
      item[:name].downcase == name_of_item.downcase
    end
  end

  def find_all_with_description(description_fragment)
    items.select do |item|
      item[:description].downcase.include?(description_fragment.downcase)
    end
  end

  def find_all_by_price(price)
    items.select do |item|
      item[:unit_price] == price
    end
  end

  def find_all_by_price_in_range

    # returns either [] or instances of Item where the supplied price is in the supplied range (a single Ruby range instance is passed in)
  end

  def find_all_by_merchant_id
    #  returns either [] or instances of Item where the supplied merchant ID matches that supplied
  end

end
