<%@ page language="java" import="java.util.*, JavaBean.*, java.sql.*,org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.servlet.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	Connection conn = DB.getConn();
	request.setCharacterEncoding("utf-8");
	String userName = request.getParameter("register_name");
	String userPassword = request.getParameter("register_password");
	/* FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload sUpload = new ServletFileUpload(factory);
	List<FileItem> fis = sUpload.parseRequest((HttpServletRequest)request);
	int fisLength = fis.size();
	String userName = null;
	String userPassword = null;
	String userPath = null;
	for(int i=0;i<fisLength;i++) {
		switch(i) {
		case 0:
			userName = fis.get(i).getString("utf-8").trim();
			break;
		case 1:
			userPath = fis.get(i).getFieldName();
			break;
		case 2:
			userPassword = fis.get(i).getString("utf-8").trim();
			break;
		}
	}	
	System.out.println(userName);
	System.out.println(userPath);
	System.out.println(userPassword); */
	String sql = "insert into user (user_name, user_password)values(?, ?)";
	PreparedStatement preState = DB.update(conn, sql);
	if(userName != null&&!userName.matches("\\s*")&&userPassword!=null&&!userPassword.matches("\\s*")) {
		preState.setString(1, userName);
		preState.setString(2, userPassword);
		preState.executeUpdate();
	}
	String content=5+";URL="+ "article.jsp";
	response.setHeader("REFRESH",content);	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>register</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
	<p>恭喜你注册成功!</p>
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

