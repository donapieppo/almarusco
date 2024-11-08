import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "show", "hide"]
  // can be "checked" if from a checkbox
  static values = { showIf: String }

  connect() {
    console.log(`Showhide with ${this.showIfValue}`)
    this.toggle()
    this.inputTarget.addEventListener("change", (event) => { this.toggle() });
  }

  toggle() {
    let ok = ((this.showIfValue == "checked") && this.inputTarget.checked) || ((this.showIfValue != "checked") && (this.inputTarget.value == this.showIfValue))
    if (this.hasShowTarget) {
      this.showTarget.style.display = (ok ? 'block' : 'none')
    }
    if (this.hasHideTarget) {
      this.hideTarget.style.display = (ok ? 'none' : 'block')
    }
  }
}
