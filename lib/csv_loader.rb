module CsvLoader

  def load(file_path)
    CSV.open(file_path, headers: true, header_converters: :symbol)
  end

end
