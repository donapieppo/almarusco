import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js";

export default class extends Controller {
  // static targets = [ "button" ]
  // static values = { id: Number }

  connect() {
    console.log("legal record");
  }

  toggleContent(event) {
    console.log("toggle content");
    console.log(event.params.url);
    get(event.params.url, {
      responseKind: "turbo-stream",
    });
  }
}

