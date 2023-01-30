import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "all" ]

        setAddress({params: { address }}) {
                console.log(address);
                document.getElementById('picking_address').value = address;
        }

        setContact({params: { contact }}) {
                console.log(contact);
                document.getElementById('picking_contact').value = contact;
        }
       checkAll(event) {
                console.log("Check all");
                document.querySelectorAll('.form-check-input').forEach(e => {
                        e.checked = 'checked';
                });
                this.allTarget.style.display = 'none';
        }
}

