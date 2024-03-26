import { Controller } from "@hotwired/stimulus"

export default class RfmController extends Controller {
  static targets = ["popoverCantLose", "rfmCells", "listItemDetail"]
  static values = { 
    groupData: Object,
    rfmData: Object
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
    let items = this.groupDataValue[group].data
    let listItemDetailHtml = ''
    items.forEach(item => {
      listItemDetailHtml += `<div class="item-detail">
        <div>${item.customer_name}</div>
        <div>${item.customer_phone}</div>
        <div>${item.days}</div>
        <div>${item.order_date}</div>
        <div>${item.order_count}</div>
        <div>${item.sum_amount}</div>
      </div>`
    })
    let listItemTitleHtml = `<h1 class="list-item-title">${group}</h1>`
    this.listItemDetailTarget.innerHTML = listItemDetailHtml
    this.listItemDetailTarget.scrollIntoView({ behavior: 'smooth', block: 'center'})
    this.listItemDetailTarget.parentElement.firstElementChild.innerHTML = listItemTitleHtml
  }

  getCustomerGroup(name) {
    return this.rfmDataValue[name]
  }
}
