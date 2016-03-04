class StandardDeviator

  def self.square_root_of_sum_divided_by(numbers_squared)
    standard_deviation = Math.sqrt((numbers_squared.reduce(:+) / (numbers_squared.length - 1)))

    standard_deviation.round(2)
  end

end
