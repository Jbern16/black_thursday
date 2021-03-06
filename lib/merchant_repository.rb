require_relative 'csv_loader'
require 'pry'
require_relative 'merchant'

class MerchantRepository
  attr_accessor :merchants
  include CsvLoader

  def initialize(file_path=nil)
    unless file_path.nil?
      @merchants = load(file_path).map { |merchant| Merchant.new(merchant)}
    end
  end

  def all
    merchants
  end

  def find_by_id(merchant_id)
    merchants.find do |merchant|
      merchant_id == merchant.id
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

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end
