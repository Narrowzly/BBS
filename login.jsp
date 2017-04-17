<%@ page language="java" import="java.util.*, JavaBean.*, java.sql.*,org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.servlet.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Connection conn = DB.getConn();
	request.setCharacterEncoding("utf-8");
	String userName = request.getParameter("login_name");
	String userPassword = request.getParameter("login_password");
	String sql = "select count(*) from user where user_name='"+userName+"'and user_password='"+userPassword+"'";
	Statement state = DB.createState(conn);
	ResultSet rs = DB.executeQuery(state, sql);
	rs.next();
	if(rs.getInt(1)>0) {
		session.setMaxInactiveInterval(600);
		session.setAttribute("username", userName);
		response.sendRedirect("articleT.jsp");
	}else {
		String content=5+";URL="+ "article.jsp";
		response.setHeader("REFRESH",content);	
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>login</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
	<p>恭喜你登录失败!</p>
	<p><span id="timer">5</span>秒后自动跳转回首页，如若不能<a href="article.jsp">点我吧</a></p>
  </body>
<script>
	var span = document.getElementById("timer");
	var timer = setInterval(function() {
		var i = parseInt(span.innerHTML);
		span.innerHTML = i-1;
		if(i-1<1) {
			clearInterval(timer);
		}
	}, 1000);
</script>
</html>



