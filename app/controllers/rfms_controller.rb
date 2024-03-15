require "csv"

class RfmsController < ApplicationController
  def show
    csv_data = CSV.read("db/rfm_sample.csv", headers: true)
    @data = transform_data(csv_data)
    @data2 = restructure_data(@data)
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

  def restructure_data(data)
    result = {
      champion: [],
      royal: [],
      potential_royal: [],
      new: [],
      promising: [],
      need_attention: [],
      need_attention_2: [],
      about_to_sleep: [],
      cant_loose: [],
      risk: [],
      hibernating: []
    }
      
    data.each do |d|
      avrg_fm = ((d[:f_score] + d[:m_score])/2.0).round(1)
      r = d[:r_score]

      if r == 5 and (4..5).include?(avrg_fm)
        # result[:champion] = 1 unless result.has_key?(:champion)
        # result[:champion] += 1
        result[:champion] << d

      elsif (3..4).include?(r) and (4..5).include?(avrg_fm)
        # result[:royal] = 1 unless result.has_key?(:royal)
        # result[:royal] += 1
        result[:royal] << d

      elsif (4..5).include?(r) and (2...4).include?(avrg_fm)
        # result[:potential_royal] = 1 unless result.has_key?(:potential_royal)
        # result[:potential_royal] += 1
        result[:potential_royal] << d

      elsif r == 5 and (1..2).include?(avrg_fm)
        # result[:new] = 1 unless result.has_key?(:new)
        # result[:new] += 1
        result[:new] << d

      elsif r == 4 and avrg_fm == 1.0
        # result[:promising] = 1 unless result.has_key?(:promising)
        # result[:promising] += 1
        result[:promising] << d

      elsif r == 3 and (1...3).include?(avrg_fm)
        # result[:need_attention] = 1 unless result.has_key?(:need_attention)
        # result[:need_attention] += 1
        result[:need_attention] << d

      elsif r == 3 and (3..4).include?(avrg_fm)
        # result[:need_attention_2] = 1 unless result.has_key?(:need_attention_2)
        # result[:need_attention_2] += 1
        result[:need_attention_2] << d

      elsif r == 3 and avrg_fm == 3.0
        # result[:about_to_sleep] = 1 unless result.has_key?(:about_to_sleep)
        # result[:about_to_sleep] += 1
        result[:about_to_sleep] << d

      elsif (1..2).include?(r) and avrg_fm == 5.0
        # result[:cant_loose] = 1 unless result.has_key?(:royal)
        # result[:cant_loose] += 1
        result[:cant_loose] << d

      elsif (1..2).include?(r) and (3..4).include?(avrg_fm)
        # result[:risk] = 1 unless result.has_key?(:risk)
        # result[:risk] += 1
        result[:risk] << d

      elsif (1..2).include?(r) and (1...3).include?(avrg_fm)
        # result[:hibernating] = 1 unless result.has_key?(:hibernating)
        # result[:hibernating] += 1
        result[:hibernating] << d

      else
        # debugger
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
end

