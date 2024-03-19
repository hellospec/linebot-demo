require "csv"

class RfmsController < ApplicationController
  def show
    csv_data = CSV.read("db/rfm_sample.csv", headers: true)
    @data = transform_data(csv_data)
    @data1 = build_customer_group(@data)
    @data2 = map_customer_group_attributes(@data1)

    @all_customers = @data2.values.sum { |d| d[:customers] }
  end

  private

  def transform_data(csv_data)
    data = build_up_base_data(csv_data)
    data = add_days(data)
    data = sort_data_for("days", data, false)
    data = add_score_column_for("r", data)

    data = sort_data_for("order_count", data)
    data = add_score_column_for("f", data)

    data = sort_data_for("sum_total_amount", data)
    data = add_score_column_for("m", data)
    data
  end

  def build_up_base_data(csv_data)
    grouped_data = csv_data.group_by { |row| [row['customer_id'], row['customer_name'], row['customer_nick_name'], row['customer_phone_number']] }
    grouped_data.map do |group, rows|
      order_count = rows.count
      sum_total_amount = rows.map { |row| row['total_amount'].to_i }.sum
      most_recent_order_date = rows.map { |row| Date.parse(row['order_date']) }.max.strftime('%Y-%m-%d')
      {
        order_count: order_count,
        order_date: most_recent_order_date,
        sum_total_amount: sum_total_amount,
        customer_id: group[0],
        customer_name: group[1],
        customer_nick_name: group[2],
        customer_phone_number: group[3]
      }
    end
  end

  def add_days(data)
    data.map do |row|
      days = (Date.parse(row[:order_date])..Date.today).count
      row[:days] = days
      row
    end
  end

  def add_score_column_for(score_name, data)
    number_of_group = 5
    number_of_records = data.size
    range = number_of_records / number_of_group
    new_column_name = :"#{score_name}_score"

    data.map.with_index do |row, index|
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

  def sort_data_for(name, data, asc=true)
    if asc
      data.sort { |a,b| a[name.to_sym] <=> b[name.to_sym] }
    else
      data.sort { |a,b| b[name.to_sym] <=> a[name.to_sym] }
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

  def build_customer_group(data)
    result = {}
    customer_group_name.each { |g| result[g.to_sym] = {data: [], customers: 0} }
    data.each do |d|
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

    result
  end

  def map_customer_group_attributes(data)
    all_customers = @data.size
    data.transform_values do |v|
      sum_customers = v[:data].size
      sum_order_count = v[:data].sum { |d| d[:order_count] }

      # the last of recent day the customer spent with in this group
      days = sum_customers == 0 ? 0 : sort_data_for("days", v[:data], false)[0][:days]

      sum_total_amount = v[:data].sum { |d| d[:sum_total_amount] }
      percentage = (sum_customers * 100.0 / all_customers).round(2)
      order_per_customer = sum_customers == 0 ? 0 : (sum_order_count / sum_customers.to_f).round(2)
      spent_per_customer = sum_total_amount == 0 ? 0 : (sum_total_amount / sum_customers.to_f).round(2)

      {
        customers: sum_customers,
        percentage: percentage,
        days: days,
        orders_per_customer: order_per_customer,
        spent_per_customer: spent_per_customer,
        position_x: v[:position_x],
        position_y: v[:position_y]
      }
    end
  end
end
