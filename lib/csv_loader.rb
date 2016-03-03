module CsvLoader

  def load(file_path)
    CSV.open(file_path, headers: true, header_converters: :symbol)
  end

  # def parse_csv(items_path, merchants_path)
  #   items = load(items).map { |row| row }
  #   merchants = load(merchants).map { |row| row }
  # end




end
