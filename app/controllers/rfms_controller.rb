require "csv"

class RfmsController < ApplicationController
  def show
    csv_data = CSV.read("db/rfm_sample.csv", headers: true)
    @data = transform_data(csv_data)
    @data2 = build_customer_group(@data)
    @data2 = map_customer_group_attributes(@data2)
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
      need_attention_2
      about_to_sleep
      cant_lose
      risk
      hibernating
    )
  end

  # [
  # {:group=>:champion, :customers=>11, :percentage=>11.0, :orders_per_customer=>4.73, :spent_per_customer=>5935.18}, 
  # {:group=>:royal, :customers=>16, :percentage=>16.0, :orders_per_customer=>4.31, :spent_per_customer=>5472.5},
  # {:group=>:potential_royal, :customers=>17, :percentage=>17.0, :orders_per_customer=>2.59, :spent_per_customer=>3008.71}, 
  # {:group=>:new, :customers=>3, :percentage=>3.0, :orders_per_customer=>1.0, :spent_per_customer=>1457.0}, 
  # {:group=>:promising, :customers=>0, :percentage=>0.0, :orders_per_customer=>0, :spent_per_customer=>0}, 
  # {:group=>:need_attention, :customers=>9, :percentage=>9.0, :orders_per_customer=>1.22, :spent_per_customer=>1675.44}, 
  # {:group=>:need_attention_2, :customers=>5, :percentage=>5.0, :orders_per_customer=>3.2, :spent_per_customer=>3616.8}, 
  # {:group=>:about_to_sleep, :customers=>0, :percentage=>0.0, :orders_per_customer=>0, :spent_per_customer=>0}, 
  # {:group=>:cant_loose, :customers=>5, :percentage=>5.0, :orders_per_customer=>6.0, :spent_per_customer=>7679.8}, 
  # {:group=>:risk, :customers=>6, :percentage=>6.0, :orders_per_customer=>3.0, :spent_per_customer=>4202.17}, 
  # {:group=>:hibernating, :customers=>28, :percentage=>28.0, :orders_per_customer=>1.43, :spent_per_customer=>1636.89}]

  def build_customer_group(data)
    result = {}
    customer_group_name.each { |g| result[g.to_sym] = {data: [], customers: 0} }
    data.each do |d|
      avrg_fm = ((d[:f_score] + d[:m_score])/2.0).round(1)
      r = d[:r_score]..d[:r_score]

      if (5..5).include?(r) and (4..5).include?(avrg_fm)
        result[:champion][:data] << d
        result[:champion][:position_x] = [4, 5]
        result[:champion][:position_y] = [3, 5]

      elsif (3..4).include?(r) and (4..5).include?(avrg_fm)
        result[:royal][:data] << d
        result[:royal][:position_x] = [2, 4]
        result[:royal][:position_y] = [3, 5]

      elsif (4..5).include?(r) and (2..3.5).include?(avrg_fm)
        result[:potential_royal][:data] << d
        result[:potential_royal][:position_x] = [3, 5]
        result[:potential_royal][:position_y] = [1, 3]

      elsif (5..5).include?(r) and (1..2).include?(avrg_fm)
        result[:new][:data] << d
        result[:new][:position_x] = [4, 5]
        result[:new][:position_y] = [0, 1]

      elsif (4..4).include?(r) and (1..1).include?(avrg_fm)
        result[:promising][:data] << d
        result[:promising][:position_x] = [3, 4]
        result[:promising][:position_y] = [0, 1]

      elsif (3..3).include?(r) and (1..2.5).include?(avrg_fm)
        result[:need_attention][:data] << d
        result[:need_attention][:position_x] = [2, 3]
        result[:need_attention][:position_y] = [0, 2]

      elsif (3..3).include?(r) and (3..4).include?(avrg_fm)
        result[:need_attention_2][:data] << d
        result[:need_attention_2][:position_x] = [2, 3]
        result[:need_attention_2][:position_y] = [0, 2]

      elsif (3..3).include?(r) and (3..3).include?(avrg_fm)
        result[:about_to_sleep][:data] << d
        result[:about_to_sleep][:position_x] = [2, 3]
        result[:about_to_sleep][:position_y] = [2, 3]

      elsif (1..2).include?(r) and (5..5).include?(avrg_fm)
        result[:cant_lose][:data] << d
        result[:cant_lose][:position_x] = [0, 2]
        result[:cant_lose][:position_y] = [4, 5]

      elsif (1..2).include?(r) and (3..4).include?(avrg_fm)
        result[:risk][:data] << d
        result[:risk][:position_x] = [0, 2]
        result[:risk][:position_y] = [2, 4]

      elsif (1..2).include?(r) and (1..2.5).include?(avrg_fm)
        result[:hibernating][:data] << d
        result[:hibernating][:position_x] = [0, 2]
        result[:hibernating][:position_y] = [0, 2]

      else
        debugger
      end
    end

    result
    # [
    #   {
    #     group: "champion",
    #     percentage: 7,
    #     customers: 504,
    #     days_since_last_order: 5,
    #     orders_per_customer: 12.50,
    #     average_ltr_per_customer: 3421.45,
    #     x_position: [5,5],
    #     y_position: [4,5]
    #   },
    #   {..},
    #   {..},
    # ]
  end

  def map_customer_group_attributes(data)
    all_customers = @data.size
    data.map do |k,v|
      sum_customers = v[:data].size
      sum_order_count = v[:data].sum { |d| d[:order_count] }
      sum_total_amount = v[:data].sum { |d| d[:sum_total_amount] }
      percentage = (sum_customers * 100.0 / all_customers).round(2)
      order_per_customer = sum_customers == 0 ? 0 : (sum_order_count / sum_customers.to_f).round(2)
      spent_per_customer = sum_total_amount == 0 ? 0 : (sum_total_amount / sum_customers.to_f).round(2)

      {
        group: k,
        customers: sum_customers,
        percentage: percentage,
        orders_per_customer: order_per_customer,
        spent_per_customer: spent_per_customer,
        position_x: v[:position_x],
        position_y: v[:position_y]
      }
    end
  end
end
