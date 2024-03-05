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

    {
      data: [
        {channel: "fb", present: present[:fb], to_compare: to_compare[:fb], percent_difference: percent_diff.call(:fb)},
        {channel: "line", present: present[:line], to_compare: to_compare[:line], percent_difference: percent_diff.call(:line)}
      ],
      compare_duration: duration.to_s
    }
  end
end
