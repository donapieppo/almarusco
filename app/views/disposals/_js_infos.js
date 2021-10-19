document.querySelectorAll(".details").forEach(x => { x.style.display = "none" });
document.querySelectorAll(".show-details").forEach(x => {
  x.addEventListener('click', (e) => {
    console.log("show infos");
    e.target.style.display = "none";
    e.target.parentElement.parentElement.querySelector(".details").style.display = "block";
  })
})

