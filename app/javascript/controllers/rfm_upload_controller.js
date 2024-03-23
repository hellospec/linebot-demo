import { Controller } from "@hotwired/stimulus"

import Papa from "papaparse"

export default class RfmUploadController extends Controller {
  static targets = ["form", "fileField"]
  static values = {
    filenames: Array
  }

  upload(event) {
    event.preventDefault()
    let file = this.fileFieldTarget.files[0]
    if(file == undefined) { return }

    let isDuplicatedFilename = this.filenamesValue.includes(file.name)
    if(isDuplicatedFilename) {
      alert("It's seem we already uploaded this file. Are you sure to process?")
      return false
    }

    let headers = ['order_id', 'order_date', 'total_amount', 'product_name', 'customer_id', 'customer_name', 'customer_nick_name', 'customer_phone_number']
    Papa.parse(file, {
      complete: (results) => {
        let isCorrectHeaders = JSON.stringify(results.data[0]) == JSON.stringify(headers)
        if(isCorrectHeaders) {
          this.formTarget.submit()
        } else {
          console.log('oops!')
        }
      }
    }) // Papa.parse
  } // upload(event)
}
