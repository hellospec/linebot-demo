class RfmDataService
  attr_reader :base_data, :group_data, :rfm_data

  def initialize(from: Date.today, to: (Date.today - 30.days))
    @all_orders = RfmOrder.all
    @data = []
  end

  def generate!
    transform_data!                  # base_data
    build_customer_group!            # group_data
    map_customer_group_attributes!   # rfm_data
  end

  def data
    rfm_data
  end

  def all_customers
    base_data.size
  end

  private

  def transform_data!
    build_up_base_data
    add_days
    @base_data = sort_data_for("days", base_data, "desc")
    add_score_column("r")

    @base_data = sort_data_for("order_count", base_data)
    add_score_column("f")

    @base_data = sort_data_for("sum_amount", base_data)
    add_score_column("m")
  end

  def build_up_base_data
    # Group the orders by customer_name and calculate order_count and sum_amount
    @base_data = @all_orders.group_by(&:customer_name).map do |customer_name, orders|
      most_recent_order_date = orders.map { |o| o.order_date }.max.strftime('%Y-%m-%d')
      {
        order_count: orders.count,
        order_date: most_recent_order_date,
        sum_amount: orders.map(&:amount).reduce(:+),
        customer_name: customer_name,
        customer_phone: orders.first.customer_phone
      }
    end
  end

  def add_days
    @base_data.each do |item|
      days = (Date.parse(item[:order_date])..Date.today).count
      item[:days] = days
    end
  end

  def sort_data_for(field_name, input, arrangement="asc")
    result = case arrangement
             when "desc"
               input.sort { |a,b| b[field_name.to_sym] <=> a[field_name.to_sym] }
             when "asc"
               input.sort { |a,b| a[field_name.to_sym] <=> b[field_name.to_sym] }
             else
               input.sort { |a,b| a[field_name.to_sym] <=> b[field_name.to_sym] }
             end
    result
  end

  def percentile
    number_of_group = 5
    number_of_records = @base_data.size
    number_of_records / number_of_group
  end

  def add_score_column(score_name)
    new_column_name = :"#{score_name}_score"
    range = percentile
    @base_data.each.with_index do |row, index|
      n = index + 1
      case n
      when n...range;             row[new_column_name] = 1
      when range...(2*range);     row[new_column_name] = 2
      when (2*range)...(3*range); row[new_column_name] = 3
      when (3*range)...(4*range); row[new_column_name] = 4
      when (4*range)..(5*range);  row[new_column_name] = 5
      end
      row
    end
  end

  def customer_group_name
    %i(
      champion
      royal
      potential_royal
      new
      promising
      need_attention
      sleep
      cant_lose
      risk
      hibernating
    )
  end

  def build_customer_group!
    result = {}
    customer_group_name.each { |g| result[g.to_sym] = {data: [], customers: 0} }
    base_data.each do |d|
      fm = ((d[:f_score] + d[:m_score])/2.0).round(1)
      r = d[:r_score]

      if (4 < r && r <= 5) and (3 < fm && fm <= 5)
        result[:champion][:data] << d

      elsif (2 < r && r <= 4) and (3 < fm && fm <= 5)
        result[:royal][:data] << d

      elsif (0 < r && r <= 2) and (4 < fm && fm <= 5)
        result[:cant_lose][:data] << d

      elsif (0 < r && r <= 2) and (2 < fm && fm <= 4)
        result[:risk][:data] << d

      elsif (2 < r && r <= 3) and (2 < fm && fm <= 3)
        result[:sleep][:data] << d

      elsif (3 < r && r <= 5) and (1 < fm && fm <= 3)
        result[:potential_royal][:data] << d

      elsif (0 < r && r <= 2) and (0 < fm && fm <= 2)
        result[:hibernating][:data] << d

      elsif (2 < r && r <= 3) and (0 < fm && fm <= 2)
        result[:need_attention][:data] << d

      elsif (3 < r && r <= 4) and (0 < fm && fm <= 1)
        result[:promising][:data] << d

      elsif (4 < r && r <= 5) and (0 < fm && fm <= 1)
        result[:new][:data] << d

      else
        raise "Huh? something wrong about rfm segmentation?"
      end
    end

    @group_data = result
  end

  def map_customer_group_attributes!
    result = group_data.transform_values do |v|
      sum_customers = v[:data].size
      sum_order_count = v[:data].sum { |d| d[:order_count] }

      # the last of recent day the customer spent with in this group
      days = sum_customers == 0 ? 0 : sort_data_for("days", v[:data], "desc")[0][:days]

      sum_total_amount = v[:data].sum { |d| d[:sum_amount] }
      percentage = (sum_customers * 100.0 / all_customers).round(2)
      avrg_order_per_customer = sum_customers == 0 ? 0 : (sum_order_count / sum_customers.to_f).round(2)
      avrg_spent_per_customer = sum_total_amount == 0 ? 0 : (sum_total_amount / sum_customers.to_f).round(2)

      {
        customers: sum_customers,
        percentage: percentage,
        days: days,
        avrg_orders: avrg_order_per_customer,
        avrg_spent: avrg_spent_per_customer
      }
    end

    @rfm_data = result
  end
end
