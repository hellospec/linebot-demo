import { Controller } from "@hotwired/stimulus"

import * as echarts from "echarts"
import {initTotalSaleChart, totalSaleChartOption} from "../src/charts/total_sale_chart"

export default class TotalSaleChartController extends Controller {
  static targets = ["chart", "totalAmount"]
  static values = { 
    data: Array 
  }

  connect() {
  }

  // Values callback
  dataValueChanged(data, previousData) {
    this.renderChart()
  }

  renderChart() {
    let chartOption = totalSaleChartOption(this.dataValue)
    let pie = initTotalSaleChart("total-sale-chart")
    pie.setOption(chartOption)
  }
}
