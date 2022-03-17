import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    console.log("modal connected");
    this.modalDiv = document.getElementById("modal-div");
    console.log(this.modalDiv)
    this.modal = bootstrap.Modal.getOrCreateInstance(this.modalDiv);
    this.modal.show()
  }

  showModal() {
    console.log("SHOW MODAL");
  }

  hideModal() {
    console.log("hideModal MODAL")
    // Without this, turbo won't re-open the modal on subsequent clicks
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
    this.modal.hide()
  }

  // hide modal on successful form submission
  // action: "turbo:submit-end->turbo-modal#submitEnd"
  // https://turbo.hotwired.dev/reference/events
  submitEnd(e) {
    console.log("Submit Modal");
    if (e.detail.success) {
      this.hideModal()
    }
  }

  followLink(e) {
    console.log("Follow link");
    this.hideModal()
    console.log(e.detail.url);
  }

  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  }

  closeBackground(e) {
    console.log(this.element);
    console.log(this.modalTarget);
    if (e && this.modalTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}
