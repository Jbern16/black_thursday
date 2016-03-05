require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'pry'
require_relative '../lib/transaction_repository'
require_relative '../lib/transaction'


class TransactionRepositoryTest < Minitest::Test
      attr_reader :transactions, :transaction_repo

 def setup

   @transaction_repo = TransactionRepository.new
   @transactions = transaction_repo.transactions =
                  [Transaction.new({
                     id: 5,
                     invoice_id: 6,
                     credit_card_number: 12220303,
                     credit_card_expiration_date: "0517",
                     result: 'success',
                     created_at: "1995-03-18 10:02:43 UTC",
                     updated_at: "1995-03-25 10:02:43 UTC"}),
                   Transaction.new({
                     id: 7,
                     invoice_id: 8,
                     credit_card_number: 12220304,
                     credit_card_expiration_date: "0519",
                     result: 'failed',
                     created_at: "1995-03-29 10:02:43 UTC",
                     updated_at: "1995-03-30 10:02:43 UTC"})]

  end

  def test_can_be_initialized_with_from_csv_with_file_path
    tr = TransactionRepository.new
    tr.from_csv("./data/transactions.csv")
    transaction = tr.find_by_id(6)
    assert_equal "success", transaction.result
  end

  def test_transaction_repo_has_array_of_transactions
    assert_equal 2, transactions.length
  end

  def test_all_returns_array_of_all_transactions
    assert transaction_repo.all
  end

  def test_find_by_id_finds_transaction_with_inputed_id
    assert_equal "success", transaction_repo.find_by_id('5').result
  end

  def test_find_by_id_returns_nil_if_not_a_match
    assert_equal nil, transaction_repo.find_by_id('8')
  end

  def test_find_all_invoice_id_finds_all_invoices_by_invoice_id
    assert_equal 1, transaction_repo.find_all_by_invoice_id(6).length
  end

  def test_find_all_by_invoice_id_returns_empty_array_if_not_found
    assert_equal [], transaction_repo.find_all_by_invoice_id(1242)
  end


  def test_find_all_by_credit_card_number_finds_all_matching_cc
    assert_equal 1, transaction_repo.find_all_by_credit_card_number(12220303).length
  end

  def test_find_all_by_credit_card_number_returns_empty_array_if_not_found
    assert_equal [], transaction_repo.find_all_by_credit_card_number(1242)
  end

  def test_find_all_by_result_finds_all_matching_invoices_by_result
    assert_equal 1, transaction_repo.find_all_by_result("success").length
  end

  def test_find_all_by_result_returns_empty_array_if_not_found
    assert_equal [], transaction_repo.find_all_by_result("pending")
  end






end
