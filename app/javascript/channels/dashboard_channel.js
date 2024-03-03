import consumer from "channels/consumer"

let dashboard = document.getElementById("dashboard")
if(dashboard != null) {
  consumer.subscriptions.create({channel: "DashboardChannel", room: "dashboard"}, {
    initialized() {
    },
    connected() {
    },
    disconnected() {
    },
    received(data) {
      this.updateDashboard(data)
    },

    updateDashboard(data) {
      // Update data-dashboard-data-value will invoke Stimulus values callback
      let dashboard = document.getElementById("dashboard")
      dashboard.dataset.dashboardDataValue = JSON.stringify(data)

      this.updateTotalSaleChart(data)
    },

    updateTotalSaleChart(data) {
      let totalSaleChart = document.querySelector("[data-controller='total-sale-chart'")
      totalSaleChart.dataset.totalSaleChartDataValue = JSON.stringify(data.amount_by_product)
    }
  })
}
