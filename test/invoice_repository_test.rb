require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'pry'
require 'bigdecimal'
require_relative '../lib/invoice_repository'


class InvoiceRepositoryTest < Minitest::Test
      attr_reader :invoices, :invoice_repo

 def setup
   time = Time.now
   @invoice_repo = InvoiceRepository.new
   @invoices = invoice_repo.invoices = [Invoice.new({
                    id: 5,
                    name: "Pencil",
                    unit_price: BigDecimal.new(1000),
                    created_at: time,
                    updated_at: time,
                    customer_id: 1555,
                    merchant_id: 1222,
                    status: "pending"
                   }),
                   Invoice.new({
                    id: 1,
                    unit_price: BigDecimal.new(1000),
                    created_at: time,
                    updated_at: time,
                    customer_id: 1555,
                    merchant_id: 1222,
                    status: "pending"
                    })]
 end

 def test_invoice_repository_exists
   assert InvoiceRepository.new
 end

 def test_all_returns_array_of_all_invoices
   assert invoice_repo.all
 end


end
