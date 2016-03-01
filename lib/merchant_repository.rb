require_relative 'csv_loader'
require 'csv'
require 'pry'

class MerchantRepository
  attr_reader :merchants

  include CsvLoader

  def initialize(file_path)
    @merchants = load(file_path).map { |row| row } if file_path  
  end


end
