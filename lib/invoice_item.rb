require 'time'

class InvoiceItem
  attr_reader :id, :invoice_id, :item_id,
              :quantity, :created_at,
              :updated_at, :unit_price

  def initialize(data)
    @id = data[:id].to_i
    @item_id = data[:item_id].to_i
    @invoice_id = data[:invoice_id].to_i
    @quantity = data[:quantity].to_i
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
    @unit_price = data[:unit_price]
  end


  def unit_price_to_dollars
      unit_price_as_dollars = unit_price / 100

      sprintf('%.2f', unit_price_as_dollars)
  end






end