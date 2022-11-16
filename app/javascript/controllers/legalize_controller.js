import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "button" ]

  connect() {
    console.log("legalize connected");
    this.buttonTarget.disabled = true;
  }

  number(event) {
    this.buttonTarget.disabled = !(parseInt(event.target.value) > 0)
  }
}
