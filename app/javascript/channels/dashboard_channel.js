import consumer from "channels/consumer"

let dashboard = document.getElementById("dashboard")
if(dashboard != null) {
  consumer.subscriptions.create({channel: "DashboardChannel", room: "line_chatbot"}, {
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
      let { amount, product, saleChannel, salePersonLineId } = data
      let value = parseInt(amount)
      let target = document.getElementById("dashboard-value")
      if(target != null) {
        let currentValue = parseInt(target.dataset.value)
        let newValue = currentValue + value

        target.textContent = newValue
        target.dataset.value = newValue
      }
    }
  })
}
