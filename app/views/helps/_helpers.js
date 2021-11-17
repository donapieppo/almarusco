document.querySelectorAll("h2.title").forEach( e => {
  let s = e.nextElementSibling;
  e.style.cursor = "pointer";
  s.style.display = "none";
  e.addEventListener('click', () => s.style.display = (s.style.display === "none") ? "block" : "none");
});

let modal = document.getElementById("imageModal");
let modalImg = document.getElementById("screeshot-image");

document.querySelectorAll(".modal-image").forEach( e => {
  console.log(e);
  e.onclick = () => {
    $('#imageModal').modal('show');
    modalImg.src = e.src;
  }
});
