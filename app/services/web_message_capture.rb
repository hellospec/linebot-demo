class WebMessageCapture
  attr_reader :current_user
  attr_reader :amount, :product_code, :channel_code

  def initialize(current_user, params)
    @current_user = current_user
    @amount = params[:amount]
    @product_code = params[:product_code]
    @channel_code = params[:channel_code]

    @new_sale = Sale.new(
      user: current_user,
      amount: amount,
      channel_code: channel_code,
      product: Product.find_by(code: product_code)
    )
  end

  def valid?
    current_user.present? and @new_sale.valid?
  end

  def create_sale!
    @new_sale.save!
  end

  def error
    @new_sale.errors.full_messages.join(",") unless valid?
  end

  def broadcast_to_dashboard
    if valid?
      # TODO
      # This broadcast should be handle by a background job
      ActionCable.server.broadcast("dashboard", Sale.dashboard_data)
    end
  end
end
