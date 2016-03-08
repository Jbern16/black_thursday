class StandardDeviator

  def self.square_root_of_sum_divided_by(numbers_squared)
    sum = numbers_squared.reduce(:+)
    standard_deviation = Math.sqrt(sum / (numbers_squared.length - 1))

    standard_deviation.round(2)
  end

end
