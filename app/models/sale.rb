class Sale < ApplicationRecord
  scope :total_amount, -> { sum(:amount) }
  scope :dashboard_data, -> {
    {
      total_amount: total_amount,
      amount_by_product: Sale.group(:product_code).sum(:amount),
      amount_by_channel: Sale.group(:channel_code).sum(:amount)
    }
  }
end
