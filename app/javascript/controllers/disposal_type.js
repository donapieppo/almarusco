import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("disposal type ststus selector connected");
  }

  show_by_status(e) {
    let selectedId = e.target.id;
    let visible_class = `status_${selectedId}`;

    document.querySelectorAll(".choosable-disposal-type").forEach((x) => {
      if (x.classList.contains(visible_class)) {
        x.style.display = 'block';
      } else {
        x.style.display = 'none';
      }
    })
  }
}
