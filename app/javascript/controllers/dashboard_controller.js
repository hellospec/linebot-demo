import { Controller } from "@hotwired/stimulus"

export default class DashboardController extends Controller {
  static targets = ["totalAmount", "totalOrder", "avrgTotalAmount", "myChart"]
  static values = { 
    data: Object 
  }

  connect() {
  }

  // Values callback
  dataValueChanged(data, previousData) {
    this.updateTotalAmount(data.total_amount)
    this.updateTotalOrder(data.total_order)
    this.updateAvrgTotalAmount(data.avrg_total_amount)
  }

  updateTotalAmount(value) {
    let cardValue = this.totalAmountTarget.querySelector(".card-value")
    cardValue.textContent = value.toLocaleString()
  }

  updateTotalOrder(value) {
    let cardValue = this.totalOrderTarget.querySelector(".card-value")
    cardValue.textContent = value.toLocaleString()
  }

  updateAvrgTotalAmount(value) {
    let cardValue = this.avrgTotalAmountTarget.querySelector(".card-value")
    cardValue.textContent = value.toLocaleString()
  }
}

