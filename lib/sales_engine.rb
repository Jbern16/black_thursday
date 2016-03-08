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
    sales_engine = self
    @merchants = MerchantRepository.new(merchants)
    @items = ItemRepository.new(items)
    @invoices = InvoiceRepository.new(invoices)
    @invoice_items = InvoiceItemRepository.new(invoice_items)
    @transactions = TransactionRepository.new(transactions)
    @customers= CustomerRepository.new(customers)

    sales_engine.inject_repos(@merchants,@items,@invoices,
                              @invoice_items, @transactions, @customers)
  end

  def self.from_csv(data)
    merchants = data[:merchants]
    items = data[:items]
    invoices = data[:invoices]
    invoice_items = data[:invoice_items]
    transactions = data[:transactions]
    customers = data[:customers]


    SalesEngine.new(merchants, items, invoices, invoice_items,
                    transactions, customers)
  end

  def inject_repos(merchants,items,invoices,invoice_items,
                   transactions, customers)

    give_item_its_merchant(merchants , items)
    give_merchant_its_items(merchants, items)
    give_invoice_its_merchant(merchants, invoices)
    give_merchant_its_invoices(merchants, invoices)
    give_transaction_its_invoice(transactions, invoices)
    give_invoice_its_items(invoice_items, invoices, items)
    give_invoice_its_customers(invoices, customers)
    give_invoice_its_invoice_items(invoices, invoice_items)
    give_customer_its_invoices(invoices,customers)
    give_merchant_its_customers(merchants, customers, invoices)
    give_customer_its_merchant(merchants, customers, invoices)
  end

  def give_item_its_merchant(merchants, items)
    items.all.each do |item|
      item.merchant = merchants.find_by_id(item.merchant_id)
    end
  end

  def give_merchant_its_items(merchants, items)
    merchants.all.each do |merchant|
      merchant.items = items.find_all_by_merchant_id(merchant.id)
    end
  end

  def give_invoice_its_merchant(merchants, invoices)
    invoices.all.each do |invoice|
      invoice.merchant = merchants.find_by_id(invoice.merchant_id)
    end
  end

  def give_merchant_its_invoices(merchants, invoices)
    merchants.all.each do |merchant|
      merchant.invoices = invoices.find_all_by_merchant_id(merchant.id)
    end
  end

  def give_transaction_its_invoice(transactions, invoices)
    transactions.all.each do |transaction|
      invoice = invoices.find_by_id(transaction.invoice_id)

      transaction.invoice = invoice
      invoice.transactions << transaction
    end
  end

  def give_invoice_its_items(invoice_items, invoices, items)
    invoice_items.all.map do |invoice_item|
      invoices.all.map do |invoice|
        match = invoice_item.invoice_id == invoice.id
        invoice.items << items.find_by_id(invoice_item.item_id) if match
      end
    end
  end

  def give_invoice_its_customers(invoices, customers)
    invoices.all.each do |invoice|
      invoice.customer = customers.find_by_id(invoice.customer_id)
    end
  end

  def give_customer_its_invoices(invoices, customers)
    customers.all.each do |customer|
      customer.invoices = invoices.find_all_by_customer_id(customer.id)
    end
  end

  def give_merchant_its_customers(merchants, customers, invoices)
    merchants.all.each do |merchant|
      merchant.customers = merchant.invoices.map do |invoice|
        customers.find_by_id(invoice.customer_id)
      end.uniq
    end
  end

  def give_customer_its_merchant(merchants, customers, invoices)
    customers.all.each do |customer|
      customer.merchants = customer.invoices.map do |invoice|
        merchants.find_by_id(invoice.merchant_id)
      end
    end
  end

  def give_invoice_its_invoice_items(invoices, ivoice_items)
    invoices.all.each do |invoice|
      invoice.invoice_items = invoice_items.find_all_by_invoice_id(invoice.id)
    end
  end

end
