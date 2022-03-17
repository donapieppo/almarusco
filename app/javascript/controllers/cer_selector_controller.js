import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("cer selector connected");
  }

  change(e) {
    let selectedId = e.target.id;
    console.log(selectedId);
    document.querySelectorAll(".disposal-card").forEach(d => {
      d.style.display = (d.dataset.cerid === selectedId) ? 'block' : 'none';
    })
  }
}
