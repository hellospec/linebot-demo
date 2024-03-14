require "csv"

class RfmsController < ApplicationController
  def show
    csv_data = CSV.read("db/rfm_sample.csv", headers: true)
    @data = transform_data(csv_data)
  end

  private

  def transform_data(csv_data)
    data = build_up_base_data(csv_data)
    data = add_days(data)
    data = sort_data_for("days", data, false)
    data = add_score_column_for("r", data)

    data = sort_data_for("order_count", data)
    data = add_score_column_for("f", data)

    # data = sort_by_sum_total_amount(data)
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
end

