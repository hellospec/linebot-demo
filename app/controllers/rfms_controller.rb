require "csv"

class RfmsController < ApplicationController
  def show
    csv_data = CSV.read("db/rfm_sample.csv", headers: true)
    data1 = transform_data(csv_data)
    data2 = add_days(data1)
    data3 = add_r_score(data2)

    data4 = sort_by_order_count(data3)
    data5 = add_f_score(data4)

    data6 = sort_by_sum_total_amount(data5)
    @data = add_m_score(data6)
  end

  private

  def transform_data(csv_data)
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
    end.sort! { |a,b| b[:days] <=> a[:days] }
  end

  def add_r_score(data)
    number_of_group = 5
    number_of_records = data.size
    range = number_of_records / number_of_group
    data.map.with_index do |row, index|
      n = index + 1
      case n
      when n...range;             row[:r_score] = 1
      when range...(2*range);     row[:r_score] = 2
      when (2*range)...(3*range); row[:r_score] = 3
      when (3*range)...(4*range); row[:r_score] = 4
      when (4*range)..(5*range);  row[:r_score] = 5
      end
      row
    end
  end

  def add_f_score(data)
    number_of_group = 5
    number_of_records = data.size
    range = number_of_records / number_of_group
    data.map.with_index do |row, index|
      n = index + 1
      case n
      when n...range;             row[:f_score] = 1
      when range...(2*range);     row[:f_score] = 2
      when (2*range)...(3*range); row[:f_score] = 3
      when (3*range)...(4*range); row[:f_score] = 4
      when (4*range)..(5*range);  row[:f_score] = 5
      end
      row
    end
  end

  def add_m_score(data)
    number_of_group = 5
    number_of_records = data.size
    range = number_of_records / number_of_group
    data.map.with_index do |row, index|
      n = index + 1
      case n
      when n...range;             row[:m_score] = 1
      when range...(2*range);     row[:m_score] = 2
      when (2*range)...(3*range); row[:m_score] = 3
      when (3*range)...(4*range); row[:m_score] = 4
      when (4*range)..(5*range);  row[:m_score] = 5
      end
      row
    end
  end

  def sort_by_order_count(data)
    data.sort! { |a,b| a[:order_count] <=> b[:order_count] }
  end

  def sort_by_sum_total_amount(data)
    data.sort! { |a,b| a[:sum_total_amount] <=> b[:sum_total_amount] }
  end
end
