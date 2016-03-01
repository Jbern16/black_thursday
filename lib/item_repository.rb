require 'csv'
require 'pry'
require_relative 'csv_loader'

class ItemRepository
  attr_reader :items
  include CsvLoader

  def initialize(file_path)
    @items = load(file_path).map { |row| row }
  end

end
