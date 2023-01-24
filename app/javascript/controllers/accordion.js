import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    console.log("Accordion loaded");
  }

  openContent(event) {
    console.log("open accordion");
    get(event.params.url, {
      responseKind: "turbo-stream",
    });
  }
}

