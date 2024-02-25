class WebMessageCapture
  attr_reader :current_user
  attr_reader :amount, :product_code, :channel_code, :error

  def initialize(current_user, params)
    @current_user = current_user
    @amount = params[:amount]
    @product_code = params[:product_code]
    @channel_code = params[:channel_code]
  end

  def valid?
    @error.blank? and current_user.present?
  end

  def create_sale!
    new_sale = Sale.create(
      user: current_user,
      amount: amount,
      product_code: product_code,
      channel_code: channel_code
    )

    unless new_sale
      @error = sale.errors.full_messages.join(",")
    end
  end

  def broadcast_to_dashboard
    if valid?
      # TODO
      # This broadcast should be handle by a background job
      #
      puts "\nwill broadcast to dashbard channel"
      # ActionCable.server.broadcast("line_chatbot", {value: value})
    end
  end
end
