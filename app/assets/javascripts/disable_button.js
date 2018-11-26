$(document).ready(() => {
  $('#accept').change(function() {
    if ($('#accept:checked').length > 0) {
      $('#cla_signature_button').prop("disabled", false);
    } else {
      $('#cla_signature_button').prop("disabled", true);
    }
  })
});
