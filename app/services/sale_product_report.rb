class SaleProductReport
  attr_reader :product
  attr_accessor :from, :to

  def initialize(product:, from: Date.today.last_month, to: Date.today)
    @product = product
    @from = from
    @to = to
  end

  def by_channel(duration: from..to)
    result = Sale.joins(:product).where(product: product, created_at: duration)
    if result.blank?
      {"line": 0, "fb": 0}
    else
      result.group('sales.channel_code').sum(:amount).symbolize_keys
    end
  end

  def by_channel_compare(period:)
    available_periods = [:last_year, :last_month, :last_week, :yesterday]
    unless available_periods.include? period.to_sym
      raise "Not recognized period #{period}"
    end

    duration = (from.public_send(period)..to.public_send(period))
    present = by_channel
    to_compare= by_channel(duration: duration)

    percent_diff = lambda do |channel|
      ((present[channel] - to_compare[channel].to_f) / present[channel] * 100).round(2)
    end

    present_channels = present.keys
    data = present_channels.map do |ch|
      {
        channel: ch.to_s,
        present: present[ch],
        to_compare: to_compare[ch],
        percent_difference: percent_diff.call(ch)
      }
    end

    {
      data: data,
      compare_duration: duration.to_s
    }
  end

  alias_method :sale_channels, :by_channel_compare

  def sale_performance
    raw = Sale.joins(:user, :product)
      .where(product: product)
      .group('users.line_display_name, users.line_picture_url, channel_code')
      .select('users.line_display_name, users.line_picture_url, channel_code, SUM(amount) AS total_amount, COUNT(channel_code) AS count')
      .map do |sale|
        {
          line_display_name: sale.line_display_name,
          line_picture_url: sale.line_picture_url,
          channel: sale.channel_code,
          total_amount: sale.total_amount,
          count: sale.count
        }
      end

    result = {}
    raw.each do |item|
      key = item[:line_display_name]
      unless result.has_key?(key)
        result[key] = {data: [], line_picture_url: item[:line_picture_url]}
      end
      result[key][:data] << {total_amount: item[:total_amount], count: item[:count], channel: item[:channel]}
    end
    result.map do |k,v|
      {
        line_display_name: k,
        line_picture_url: v[:line_picture_url],
        data: v[:data]
      }
    end
  end
end
