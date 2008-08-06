
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

function add_tag(item,url) {
	$.post( 
		url,
		{
			type: "post",
			tag: item.text,
			authenticity_token: authenticity_token,
			_method: "put"
		}	,
		function(result) {
			$(item).parent().replaceWith(result);
		}
	);
return true;
}


function delete_tag(item,url) {
	$.post( 
		url,
		{
			type: "post",
			tag: $(item).prev().text(),
			authenticity_token: authenticity_token,
			_method: "delete",
		},
		function(result) {
			$(item).parent().replaceWith(result);
		}
	);
return true;
}