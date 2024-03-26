require "csv"

class RfmsController < ApplicationController
  def show
    d1 = Date.today
    d2 = d1 - 60.days

    rfm = RfmDataService.new(from: d2, to: d1)
    rfm.generate!
    @group_data = rfm.group_data
    @rfm_data = rfm.rfm_data
    @all_customers = rfm.all_customers
  end
end
