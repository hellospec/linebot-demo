class ProductsController < ApplicationController
  before_action :authenticate_sale_person

  def index
  end

  def show
    id = params[:id]
    @product = is_integer?(id) ? Product.find(id) : Product.find_by(slug: id)
    @report = SaleProductReport.new(product: @product)

    @channel_compare = @report.by_channel_compare(period: :last_month)
    @sale_performance = @report.sale_performance
  end

  private

  def is_integer?(id)
    !!Integer(id)
  rescue ArgumentError, TypeError
    false
  end
end
