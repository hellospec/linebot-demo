class LineMessageCapture
  attr_reader :message
  attr_reader :amount, :product, :sale_channel, :error

  def initialize(message)
    # Validate message format
    # example of valid message
    # ppt 2500 productA fb
    # ppt 2000 productA line
    # ppt line 2000 productA
    # ppt productA line 2000
    #
    @message = message
    extract
  end

  def valid?
    @error.blank?
  end

  def has_all_attributes?
    amount.present? and product.present? and sale_channel.present?
  end

  private

  def extract
    if message.match(/^ppt.*\s/)
      find_amount
      find_product
      find_sale_channel
    end
  rescue => e
    puts " !!!"
    @error = e.message
  end

  def find_amount
    raise "amount is not found!" if message.match(/^ppt.*\s(\d+)/).blank?

    @amount = $1
  end

  def find_product
    available_products = %w[producta productb productc]
    @product = available_products.find do |a|
      rg = Regexp.new("^ppt.*\s#{a}")
      message.downcase.match(rg)
    end

    raise "product is not found!" if @product.blank?
  end

  def find_sale_channel
    available_sale_channels = %w[fb line]
    @sale_channel = available_sale_channels.find do |a|
      rg = Regexp.new("^ppt.*\s#{a}")
      message.downcase.match(rg)
    end

    raise "sale channel is not found!" if @sale_channel.blank?
  end
end
