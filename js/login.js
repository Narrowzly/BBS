$(document).ready(function() {
		$('#login').modal({backdrop: 'static', keyboard: false, show:false});
		$('#login_button').click(function() {
			$('#login_form').submit();
		}); 
	}
);