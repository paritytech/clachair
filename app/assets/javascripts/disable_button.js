$(document).ready(() =>
  $('#accept').change(() =>
    $('#cla_signature_button').prop("disabled", !$('#accept:checked').length)
  )
);