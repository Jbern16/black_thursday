require 'csv'
require 'pry'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'

class SalesEngine
  attr_reader :items, :merchants, :invoices, :customers,
              :transactions, :invoice_items

  def initialize(merchants, items, invoices=nil, invoice_items=nil,
                transactions=nil, customers=nil)

    @merchants = merchants
    @items = items
    @invoices = invoices
    @invoice_items = invoice_items
    @transactions = transactions
    @customers= customers

  end

  def self.from_csv(data)
    merchants = MerchantRepository.new(data[:merchants])
    items = ItemRepository.new(data[:items])
    invoices = InvoiceRepository.new(data[:invoices])
    invoice_items = InvoiceItemRepository.new.from_csv(data[:invoice_items], items, invoices)
    transactions = TransactionRepository.new.from_csv(data[:transactions])
    customers = CustomerRepository.new.from_csv(data[:customers])


    inject_repos(merchants,items,invoices,invoice_items, transactions)

    SalesEngine.new(merchants, items, invoices,
                    invoice_items, transactions,
                    customers)
  end

  def self.inject_repos(merchants,items,invoices,invoice_items, transactions)
    give_item_its_merchant(merchants , items)
    give_merchant_its_items(merchants, items)

    unless invoices.all.nil?
      give_invoice_its_merchant(merchants, invoices)
      give_merchant_its_invoices(merchants, invoices)
    end

    unless invoice_items.nil?
      give_transaction_its_invoice(transactions, invoices)
      give_invoice_its_items(invoice_items, invoices, items)
    end
  end

  def self.give_item_its_merchant(merchants, items)
    items.all.each do |item|
      item.merchant = merchants.find_by_id(item.merchant_id)
    end
  end

  def self.give_merchant_its_items(merchants, items)
    merchants.all.each do |merchant|
      merchant.items = items.find_all_by_merchant_id(merchant.id)
    end
  end

  def self.give_invoice_its_merchant(merchants, invoices)
    invoices.all.each do |invoice|
      invoice.merchant = merchants.find_by_id(invoice.merchant_id)
    end
  end

  def self.give_merchant_its_invoices(merchants, invoices)
    merchants.all.each do |merchant|
      merchant.invoices = invoices.find_all_by_merchant_id(merchant.id)
    end
  end

  def self.give_transaction_its_invoice(transactions, invoices)
    transactions.each do |transaction|
      invoice = invoices.find_by_id(transaction.invoice_id)

      transaction.invoice = invoice
      invoice.transactions << transaction
    end
  end

  def self.give_invoice_its_items(invoice_items, invoices, items)
    invoice_items.map do |invoice_item|
      invoices.all.map do |invoice|

        if invoice_item.invoice_id == invoice.id
          invoice.items << items.find_by_id(invoice_item.item_id)
          invoice.items.map do |item|
            item.merchant = []
          end
        end
      end
    end
  end

end
