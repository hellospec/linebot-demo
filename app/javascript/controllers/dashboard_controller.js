import { Controller } from "@hotwired/stimulus"

export default class DashboardController extends Controller {
  static targets = ["totalAmount", "productAmount", "channelAmount"]
  static values = { 
    data: Object 
  }

  // Values callback
  dataValueChanged(data, previousData) {
    this.updateTotalAmount(data.total_amount)
    this.updateAmountFor("product", data.amount_by_product)
    this.updateAmountFor("channel", data.amount_by_channel)
  }

  updateTotalAmount(totalAmount) {
    this.totalAmountTarget.textContent = totalAmount
  }

  updateAmountFor(name, amounts) {
    Object.keys(amounts).forEach(k => {
      let newValue = parseInt(amounts[k])
      let targetName = name + "AmountTarget"

      let target = this[targetName].querySelector(`#amount-${k}`)
      if(target.dataset.amount != newValue) {
        target.dataset.amount = newValue
        target.querySelector(".amount").textContent = newValue
        target.querySelector(".amount").classList.add("text-blue-500")
      }
    })
  }
}

