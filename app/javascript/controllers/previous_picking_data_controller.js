import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("previous picking data");
  }

  setAddress({params: { address }}) {
    console.log(address);
    document.getElementById('picking_address').value = address;
  }

  setContact({params: { contact }}) {
    console.log(contact);
    document.getElementById('picking_contact').value = contact;
  }
}


