require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/merchant'


class MerchantTest < Minitest::Test

  def test_marchant_is_created_with_an_id_and_name
    merchant = Merchant.new({id: 5, name: "Turing School"})

    assert_equal 5, merchant.id
    assert_equal "Turing School", merchant.name
  end

end
