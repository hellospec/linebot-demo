class Sale < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :product_code, presence: true
  validates :channel_code, presence: true

  scope :total_amount, -> { sum(:amount) }
  scope :dashboard_data, -> {
    total_order = Sale.count
    {
      total_order: total_order,
      total_amount: total_amount,
      avrg_total_amount: (total_amount.to_f/total_order).round(2),
      amount_by_product: sum_amount_of(:product_code),
      amount_by_channel: sum_amount_of(:channel_code),
      amount_product_channel: amount_by_product_channel
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

    def amount_by_product_channel
      Sale.group(:product_code, :channel_code).sum(:amount)
        .each_with_object({}) do |((product, channel), amount), item|
          item[product.to_sym] ||= {}
          item[product.to_sym][channel.to_sym] = amount
        end
    end
  end
end
