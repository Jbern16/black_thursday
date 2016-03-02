require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/merchant'


class MerchantTest < Minitest::Test
  attr_reader :merchant
  
  def setup
    @merchant = Merchant.new({id: 5, name: "Turing School"})
  end

  def test_marchant_is_created_with_an_id
    assert_equal 5, merchant.id
  end

  def test_marchant_is_created_with_a_name
    assert_equal "Turing School", merchant.name
  end

end
