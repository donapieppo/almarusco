function visible_checked () {
  document.querySelectorAll('.picking-disposal').forEach (element => {
    checked = element.querySelectorAll('input')[0].checked;
    card_title = element.querySelectorAll('.dm-card-title')[0]
    if (checked) {
      card_title.classList.add("text-white", "bg-info");
    } else {
      card_title.classList.remove("text-white", "bg-info");
    }
  })
}

document.querySelectorAll('.picking-disposal').forEach (element => {
  element.addEventListener('click', () => {
    chb = element.querySelectorAll('input')[0];
    chb.checked = ! chb.checked;
    visible_checked()
  })
})

// start
visible_checked();
