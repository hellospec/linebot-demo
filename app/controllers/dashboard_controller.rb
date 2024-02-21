class DashboardController < ApplicationController
  def show
    @data = Sale.dashboard_data
    @total_amount = @data[:total_amount]
    @amount_by_product = @data[:amount_by_product]
    @amount_by_channel = @data[:amount_by_channel]
  end
end
