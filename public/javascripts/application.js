
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept",
    "text/javascript")} 
})

function hide_all(selectbox) {
	$(selectbox).children('option').each( function(a,b) {
		if (b.text != "") {
			$("." + b.text.toLowerCase()).hide();
		}
	});
}

function show(klass) {
	$("." + klass.toLowerCase()).show();
}

function add_tag(url, tag) {
	$.ajax( 
		{
		url: url,
		tag: tag,
		type: "post",
		authenticity_token: authenticity_token,
		method: "put"
		}
	);
return true;
}