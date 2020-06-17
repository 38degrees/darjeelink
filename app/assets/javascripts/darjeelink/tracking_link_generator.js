function generateTrackingLink(){
  var url = $('#base-url').val();
  if (!url) {
    document.getElementById("long_url").value = "";
    return;
  }

  var sourceMedium = $('#source-medium').val();
  var source = sourceMedium.split('-')[0];
  var medium = sourceMedium.split('-')[1];

  var id = $('#campaign').val();
  var today = new Date();
  var dd = today.getDate();
  var mm = today.getMonth()+1; //January is 0!
  var yyyy = today.getFullYear();

  var campaign = dd + "_" + mm + "_" + yyyy + "_" + id

  var queryString = ["utm_source=",source,"&utm_medium=",medium,"&utm_campaign=",campaign,"&bucket=",source,"-",medium,"-",campaign].join('');

  if (url.indexOf('?') > -1) {
    firstCharacter = '&';
  } else {
    firstCharacter = '?'
  }

  document.getElementById("long_url").value = (url + firstCharacter + queryString);
}

$(document).ready(function(){
  $("#tracking :input").change(function() {
    generateTrackingLink();
  });

  $("#tracking").keyup(function(){
    generateTrackingLink();
  });

  document.getElementById("long_url").readOnly = true;
});
