class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :channel_code, presence: true

  scope :total_amount, -> { sum(:amount) }
  scope :dashboard_data, -> {
    total_order = Sale.count
    avrg_total_amount = total_order == 0 ? 0 : (total_amount.to_f/total_order).round(2)
    {
      total_order: total_order,
      total_amount: total_amount,
      avrg_total_amount: avrg_total_amount,
      amount_by_product: sum_amount_of_product,
      amount_by_channel: sum_amount_of_channel,
      amount_product_channel: amount_by_product_channel
    }
  }

  class << self
    def sum_amount_of_product
      Sale.joins(:product).group('products.code', 'products.slug').sum(:amount).map do |k,v|
        {
          product: k[0],
          product_slug: k[1],
          amount: v
        }
      end
    end

    def sum_amount_of_channel
      data = Sale.group(:channel_code).sum(:amount)
      data.map do |k,v|
        {channel: k, amount: v}
      end
    end

    def amount_by_product_channel
      Sale.joins(:product).group('products.code', :channel_code).sum(:amount)
        .each_with_object({}) do |((product, channel), amount), item|
          item[product.to_sym] ||= {}
          item[product.to_sym][channel.to_sym] = amount
        end
    end
  end
end
