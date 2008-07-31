
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept",
    "text/javascript")} 
})

function hide_all(selectbox) {
	$(selectbox.options).each( function(a,b) {
		if (b.text != "") {
			$("." + b.text.toLowerCase()).hide(); 
		} });
}

function show(klass) {
	$("." + klass.toLowerCase()).show();
}