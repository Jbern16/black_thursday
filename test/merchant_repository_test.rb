require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/merchant'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :mr, :merchants

  def setup
    @mr = MerchantRepository.new
    @merchants = mr.merchants =
                  [Merchant.new({id: 5, name: "Turing School"}),
                  Merchant.new({id: 7, name: "Tom School"}),
                  Merchant.new({id: 9, name: "CoolDecor"})]
  end

  def test_all_method_returns_array
    merchant = mr.all

    assert_equal @merchants, merchant
  end

  def test_find_by_id_method_returns_merchant_with_matching_id
    answer = "Tom School"
    merchant = mr.find_by_id(7)

    assert_equal answer, merchant.name
  end

  def test_find_by_id_method_returns_nil_if_doesnt_match_merchants
    merchant = mr.find_by_id("999999999")

    assert_equal nil, merchant
  end

  def test_find_by_name_method_returns_merchant_with_matching_name
    merchant = mr.find_by_name("Tom School")

    assert_equal 7, merchant.id
  end

  def test_find_by_name_method_returns_merchant_with_matching_name_even_if_case_is_off
    merchant = mr.find_by_name("CoOlDECOR")

    assert_equal 9, merchant.id
  end

  def test_find_by_name_method_returns_nil_if_doesnt_match_merchants
    answer = nil
    merchant = mr.find_by_name("Snot Catcher")

    assert_equal answer, merchant
  end

  def test_find_all_by_name_method_returns_array_of_matching_merchants
    answer = "Turing School"
    answer2 = "Tom School"
    merchants = mr.find_all_by_name("Scho")

    assert_equal answer, merchants[0].name
    assert_equal answer2, merchants[1].name
  end

end
