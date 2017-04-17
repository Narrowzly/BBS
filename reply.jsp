<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*, java.util.Date, JavaBean.*, java.util.*"%>
<%
	Connection conn = DB.getConn();
	request.setCharacterEncoding("utf-8");
	PreparedStatement preState = null;
	Statement state = DB.createState(conn);
	String id = request.getParameter("id");
	String author = (String)session.getValue("username");
	if(author==null) {
		out.println("登录已过期");
		out.println("<a href='article.jsp'>返回主页</a>");
	}
 	String titleResponse = request.getParameter("titleResponse");
 	boolean insert = false;
 	String sql1 = "select title from bbs where id ="+id;
 	ResultSet rs = DB.executeQuery(state, sql1);
 	rs.next();
 	String title = rs.getString(1);
	if(titleResponse != null&&!titleResponse.matches("\\s*")) {
		String sql = "insert into bbs (pid, title, content, publishDate, author) values(?, ?, ?, ?, ?)";
		preState = DB.update(conn, sql);
		preState.setInt(1, Integer.parseInt(id));
		preState.setString(2, title);
		preState.setString(3, titleResponse);
		Date now = new Date();
		Timestamp timeStamp = new Timestamp(now.getTime());
		preState.setTimestamp(4, timeStamp);
		preState.setString(5, author);
		preState.executeUpdate();
		insert = true;
		preState.close();		
	}
	conn.close();
	if(insert) {
		response.sendRedirect("contentT.jsp?id="+id);
	}else {
		response.sendRedirect("error.jsp");
	}
%>