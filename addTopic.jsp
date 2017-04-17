<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*, java.util.Date, JavaBean.*, java.util.*"%>
<%
	Connection conn = DB.getConn();
	request.setCharacterEncoding("utf-8");	
	String topicTitle = request.getParameter("topicTitle");
	String topicContent = request.getParameter("topicContent");
	String author = (String)session.getValue("username");
	if(author==null) {
		out.println("登录已过期");
		out.println("<a href='article.jsp'>返回主页</a>");
	}
	String sql = "insert into bbs (pid, title, content, publishDate,author) values(?, ?, ?, ?, ?)";
	PreparedStatement preState = DB.update(conn, sql);
	boolean insert = false;
	if(topicTitle != null&&!topicTitle.matches("\\s*")&&topicContent!=null&&!topicContent.matches("\\s*")) {
		preState.setInt(1, 0);
		preState.setString(2, topicTitle);
		preState.setString(3, topicContent);
		Date now = new Date();
		Timestamp timeStamp = new Timestamp(now.getTime());
		preState.setTimestamp(4, timeStamp);
		preState.setString(5, author);
		preState.executeUpdate();
		insert = true;
	}
	preState.close();
	conn.close();
	if(insert) {
		response.sendRedirect("articleT.jsp");
	}else {
		response.sendRedirect("error.jsp");
	}
%>