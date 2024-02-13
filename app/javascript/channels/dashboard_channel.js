import consumer from "channels/consumer"

let dashboard = document.getElementById("dashboard")
if(dashboard != null) {
  console.log(dashboard)
  consumer.subscriptions.create({channel: "DashboardChannel", room: "line_chatbot"}, {
    initialized() {
    },
    connected() {
    },
    disconnected() {
    },
    received(data) {
      let v = parseInt(data.value)
      this.updateDashboardValue(v)
    },

    updateDashboardValue(value) {
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
