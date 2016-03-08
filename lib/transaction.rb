require 'time'


class Transaction
  attr_reader :id, :invoice_id, :credit_card_number,
              :credit_card_expiration_date, :result,
              :created_at, :updated_at

  attr_accessor :invoice

  def initialize(data)
    @id = data[:id].to_i
    @invoice_id = data[:invoice_id].to_i
    @credit_card_number = data[:credit_card_number].to_i
    @credit_card_expiration_date = data[:credit_card_expiration_date]
    @result = data[:result]
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
    @invoice = nil
  end

  def inspect
    "#<#{self.class}>"
  end

  def success
    result == "success"
  end
end
