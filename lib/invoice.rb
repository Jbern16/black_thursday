class Invoice
  attr_reader :id, :unit_price, :created_at,
              :updated_at, :customer_id,
              :status, :merchant_id

  def initialize(data)
    @id = data[:id].to_i
    @unit_price = data[:unit_price]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @customer_id = data[:customer_id]
    @status = data[:status]
    @merchant_id = data[:merchant_id].to_i
  end
end
