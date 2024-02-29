import { Controller } from "@hotwired/stimulus"

import * as echarts from "echarts"
import {initMyChart, myChartOption} from "../src/charts/my_chart"

export default class DashboardController extends Controller {
  static targets = ["totalAmount", "productAmount", "channelAmount", "myChart"]
  static values = { 
    data: Object 
  }

  connect() {
  }

  // Values callback
  dataValueChanged(data, previousData) {
    this.updateTotalAmount(data.total_amount)
    this.renderChart()
  }

  chartOption() {
    let data = this.dataValue.amount_by_product
    return myChartOption(data)
  }

  renderChart() {
    let option = this.chartOption()
    let pie = initMyChart("my-chart")
    pie.setOption(option)
  }

  updateTotalAmount(totalAmount) {
    this.totalAmountTarget.textContent = totalAmount
  }
}

