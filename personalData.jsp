<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*, java.util.Date, JavaBean.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String username = (String)session.getValue("username");	
%>
<html>
<head>
</head>
<body>
	<form action="Upload?username=<%=username %>" enctype="multipart/form-data" method='post'>
		<input type="file" name='headPic'/>
		<input type='submit' value='上传头像'/>
	</form>
</body>
</html>