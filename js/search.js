$(document).ready(function() {
	$('#search').click(function() {
		var content = $('#searchContent').val();
		$('#search').attr('href', 'search.jsp?problem='+content);
	});
	$('#searchT').click(function() {
		var content = $('#searchContentT').val();
		$('#searchT').attr('href', 'searchT.jsp?problem='+content);
	});
}); 