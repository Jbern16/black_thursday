require_relative 'csv_loader'
require_relative 'merchant'
require 'csv'
require 'pry'

class MerchantRepository
  attr_accessor :merchants, :items

  include CsvLoader

  def initialize(file_path=nil, items=nil)
    unless file_path.nil?
      @merchants = load(file_path).map { |merchant| Merchant.new(merchant)}#, items)}
    end
    @items = items
  end

  def all
    merchants
  end

  def find_by_id(merchant_id)
    merchants.find do |merchant|
      merchant.id == merchant_id
    end
  end

  def find_by_name(name_of_merchant)
    merchants.find do |merchant|
      merchant.name.downcase == name_of_merchant.downcase
    end
  end

  def find_all_by_name(name_fragment)
    merchants.select do |merchant|
      merchant.name.downcase.include?(name_fragment.downcase)
    end
  end

end
