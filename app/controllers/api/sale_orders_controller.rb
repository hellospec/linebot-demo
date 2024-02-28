class Api::SaleOrdersController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api!

  def create
    capture = ApiMessageCapture.new(current_user, sale_order_params)
    if capture.valid?
      sale = capture.create_sale!
      capture.broadcast_to_dashboard

      render json: sale
    else
      render json: {error: capture.error}, status: :unprocessable_entity
    end

  rescue => e
    render json: {error: e.to_s}, status: :bad_request and return
  end

  private

  def sale_order_params
    params.require(:sale).permit(
      :product_code,
      :channel_code,
      :amount
    )
  end
end
