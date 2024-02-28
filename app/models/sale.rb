class Sale < ApplicationRecord
  belongs_to :user

  scope :total_amount, -> { sum(:amount) }
  scope :dashboard_data, -> {
    {
      total_amount: total_amount,
      amount_by_product: Sale.group(:product_code).sum(:amount),
      amount_by_channel: Sale.group(:channel_code).sum(:amount)
    }
  }

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :product_code, presence: true
  validates :channel_code, presence: true
end
