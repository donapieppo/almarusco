import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("disposal selector connected");
  }

  change_cer(event) {
    let selectedId = event.target.id;
    console.log(selectedId);
    document.querySelectorAll(".disposal-card").forEach(d => {
      d.style.display = (d.dataset.cerid === selectedId) ? 'block' : 'none';
    })
  }

  toggle_missing_kgs(event) {
    document.querySelectorAll(".disposal-card").forEach(d => {
      d.style.display = (d.dataset.withkgs === 'true') ? 'none' : 'block';
    })
    event.preventDefault();
  }
}
