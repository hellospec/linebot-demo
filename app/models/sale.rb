class Sale < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :product_code, presence: true
  validates :channel_code, presence: true

  scope :total_amount, -> { sum(:amount) }
  scope :dashboard_data, -> {
    {
      total_amount: total_amount,
      amount_by_product: sum_amount_of(:product_code),
      amount_by_channel: sum_amount_of(:channel_code)
    }
  }

  class << self
    def sum_amount_of(name)
      raise "Not recognize name: #{name}" unless Sale.column_names.include? name.to_s

      data = Sale.group(name.to_sym).sum(:amount)
      data.map do |k,v|
        {product: k, amount: v}
      end
    end
  end
end
