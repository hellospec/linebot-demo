# The LineMessageCapture instance take 2 arguments, message and line_user_id
# The message is a pattern of string that contains information of sale order.
# Here is an example of valid messages (valid sale orders)
#
# ```
# ppt 2500 productA fb
# ppt 2000 productA line
# ppt line 2000 productA
# ppt productA line 2000
# ```

class LineMessageCapture
  attr_reader :message, :line_user_id
  attr_reader :sale_person, :amount, :product_code, :channel_code, :error

  def initialize(message, line_user_id)
    @line_user_id = line_user_id
    @message = message

    valid_message_command = message.match(/^ppt.*\s/)
    if valid_message_command
      find_sale_person
      find_amount
      find_product_code
      find_channel_code

      @new_sale = Sale.new(
        user: sale_person,
        amount: amount,
        channel_code: channel_code,
        product: Product.find_by(code: product_code)
      )
    end
  rescue => e
    @error = e.message
  end

  def valid?
    @error.blank? and has_all_attributes?
  end

  def create_sale!
    @new_sale.save!

  rescue => _
    @error = @new_sale.errors.full_messages.join(",")
  end

  def broadcast_to_dashboard
    if valid?
      # TODO
      # This broadcast should be handle by a background job
      ActionCable.server.broadcast("dashboard", Sale.dashboard_data)
    end
  end

  def has_all_attributes?
    sale_person.present? and amount.present? and product_code.present? and channel_code.present?
  end

  private

  def find_sale_person
    @sale_person = User.find_by_line_user_id line_user_id
    raise "sale person is not found!" if @sale_person.blank?
  end

  def find_amount
    raise "amount is not found!" if message.match(/^ppt.*\s(\d+)/).blank?

    @amount = $1
  end

  def find_product_code
    available_products = Product.pluck(:code)
    @product_code = available_products.find do |a|
      rg = Regexp.new("^ppt.*\s#{a}")
      message.downcase.match(rg)
    end

    raise "product is not found!" if @product_code.blank?
  end

  def find_channel_code
    available_sale_channels = %w[fb line]
    @channel_code = available_sale_channels.find do |a|
      rg = Regexp.new("^ppt.*\s#{a}")
      message.downcase.match(rg)
    end

    raise "sale channel is not found!" if @channel_code.blank?
  end
end
