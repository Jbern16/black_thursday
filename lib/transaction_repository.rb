require_relative 'csv_loader'
require_relative 'transaction'

class TransactionRepository
  attr_accessor :transactions
  include CsvLoader

  def initialize(file_path=nil)
    from_csv(file_path)
  end

  def from_csv(file_path)
    unless file_path.nil?
      @transactions = load(file_path).map do |transaction|
        Transaction.new(transaction)
      end
    end
  end


  def all
    @transactions
  end

  def find_by_id(transaction_id)
    transactions.find do |transaction|
      transaction.id.to_i == transaction_id.to_i
    end
  end

  def find_all_by_invoice_id(invoice_id)
    transactions.select do |transaction|
      transaction.invoice_id.to_i == invoice_id.to_i
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    transactions.select do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    transactions.select do |transaction|
      transaction.result == result
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end
