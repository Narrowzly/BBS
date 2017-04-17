$(document).ready(function() {
	$('#register').modal({backdrop: 'static', keyboard: false, show:false});
	$('#register_button').click(function() {
		$('#register_form').submit();
	}); 
	$('#register_name').blur(function() {
		$.ajax({
			type:"POST",
			url:"check.jsp",
			data:{userName:$('#register_name').val()},
			success:function(reminder) {
						$('#userName_reminder').attr('class','');
						console.log(reminder);
						if(reminder.trim() === "true") {//check.jsp有换行符两段代码之间
							$('#userName_reminder').addClass('alert alert-danger');
							$('#userName_reminder').text('用户名已经存在请换个名字试一试');
						}else {
							$('#userName_reminder').addClass('alert alert-success');
							$('#userName_reminder').text('用户名可用,是独一无二的哦');
						}
					}
		});
	});
});
