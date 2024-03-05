import { Controller } from "@hotwired/stimulus"

import * as echarts from "echarts"
import {initTotalSaleChart, totalSaleChartOptionFocus} from "src/charts/total_sale_chart"

export default class TotalSaleChartFocusController extends Controller {
  static targets = ["chart", "totalAmount", "dataTable"]
  static values = { 
    data: Array,
    product: String
  }

  connect() {
  }

  // Values callback
  dataValueChanged(data, previousData) {
    this.renderChart()
  }

  renderChart() {
    let chartOption = totalSaleChartOptionFocus(this.dataValue, this.productValue)
    let pie = initTotalSaleChart("total-sale-chart")
    pie.setOption(chartOption)
  }
}
