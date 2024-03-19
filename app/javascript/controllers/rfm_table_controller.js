import { Controller } from "@hotwired/stimulus"

export default class RfmTableController extends Controller {
  static targets = ["sectionR", "sectionF", "sectionM"]

  viewSection(event) {
    let targetName = event.params.section + "Target"

    // hide all section
    this.hideAllSections()

    // show only the selected section
    this[targetName].classList.remove("hidden")
  }

  hideAllSections() {
    this.sectionRTarget.classList.add("hidden")
    this.sectionFTarget.classList.add("hidden")
    this.sectionMTarget.classList.add("hidden")
  }
}
