import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "building", "labs" ]

  connect() {
    console.log("disposal lab selector connected");
  }

  change_building(e) {
    console.log(`change building -> ${e.target.value}`);
    this.labsTarget.value = 0;
    this.labsTarget.querySelectorAll("option").forEach( (o) => {
      o.style.display = (o.dataset.buildingId == e.target.value) ? 'block' : 'none';
    });
  }
}
