class SaleOrdersController < ApplicationController
  before_action :authenticate_sale_person

  def new
  end

  def create
    capture = WebMessageCapture.new(current_user, sale_order_params)

    if capture.valid?
      capture.create_sale!
      capture.broadcast_to_dashboard
      redirect_to root_path, status: :see_other
    else
      render turbo_stream: [
        turbo_stream.replace(
          "error-message",
          partial: "sale_orders/error_message",
          locals: {object: capture}
        )
      ]
    end
  end

  private

  def sale_order_params
    params.require(:sale).permit(
      :product_code,
      :channel_code,
      :amount
    )
  end

  def match_with_line_id
    line_user_id = params[:sale][:line_user_id]
    return false if line_user_id.blank?

    user_from_line_id = User.find_by_line_user_id line_user_id
    current_user = user_from_line_id
  end
end
