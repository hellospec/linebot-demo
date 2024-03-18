import { Controller } from "@hotwired/stimulus"

import * as echarts from "echarts"

export default class RfmController extends Controller {
  static targets = ["popoverCantLose", "rfmCells", "listItemDetail"]
  static values = { 
    data1: Object,
    data2: Object
  }

  connect() {
    // this.renderRfmGrid()
    console.log('connect to rfm controller')
    // console.log(this.dataValue)
  }

  highlight(cell) {
    this.rfmCellsTarget.querySelectorAll(".cell").forEach(c => c.classList.add("drop-cell"))
    cell.classList.remove("drop-cell")
  }

  showDetail(event) {
    // highlight cell
    this.highlight(event.currentTarget)

    // show line items of the selected group
    let group = event.currentTarget.dataset.group
    let items = this.data1Value[group].data
    let listItemDetailHtml = ''
    items.forEach(item => {
      listItemDetailHtml += `<div class="item-detail">
        <div>${item.customer_name}</div>
        <div>${item.customer_phone_number}</div>
        <div>${item.days}</div>
        <div>${item.order_date}</div>
        <div>${item.order_count}</div>
        <div>${item.sum_total_amount}</div>
      </div>`
    })
    let listItemTitleHtml = `<h1 class="list-item-title">${group}</h1>`
    this.listItemDetailTarget.innerHTML = listItemDetailHtml
    this.listItemDetailTarget.scrollIntoView({ behavior: 'smooth', block: 'center'})
    this.listItemDetailTarget.parentElement.firstElementChild.innerHTML = listItemTitleHtml
  }

  getCustomerGroup(name) {
    return this.data2Value[name]
  }

  renderRfmGrid() {
    let container = document.getElementById("rfm-grid")
    if(container == null) { return }

  }
}
