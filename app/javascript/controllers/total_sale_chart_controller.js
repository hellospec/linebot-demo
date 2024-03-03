import { Controller } from "@hotwired/stimulus"

import * as echarts from "echarts"
import {initTotalSaleChart, totalSaleChartOption} from "../src/charts/total_sale_chart"

export default class TotalSaleChartController extends Controller {
  static targets = ["chart", "totalAmount", "dataTable"]
  static values = { 
    data: Array 
  }

  connect() {
  }

  // Values callback
  dataValueChanged(data, previousData) {
    this.renderChart()
    this.renderDataTable()
  }

  renderChart() {
    let chartOption = totalSaleChartOption(this.dataValue)
    let pie = initTotalSaleChart("total-sale-chart")
    pie.setOption(chartOption)
  }

  renderDataTable() {
    this.dataValue.forEach(d => {
      let valueElement = this.dataTableTarget.querySelector(`[data-product-name="${d.product}"]`)
      valueElement.textContent = d.amount.toLocaleString()
    })
    this.totalAmountTarget.textContent = this.totalAmount().toLocaleString()
  }

  totalAmount() {
    return this.dataValue.reduce((acc, d) => acc + d.amount, 0)
  }
}
