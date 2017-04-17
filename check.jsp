<%@ page language="java" import="java.util.*, JavaBean.*, java.sql.*, java.io.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Connection conn = DB.getConn();
	Statement state = DB.createState(conn);
	request.setCharacterEncoding("utf-8");
	String userName = request.getParameter("userName");
	String sql = "select count(*) from user where user_name ='"+userName+"'";
	ResultSet rs = DB.executeQuery(state, sql);
	response.setCharacterEncoding("utf-8");
	PrintWriter pw = response.getWriter(); 
	rs.next();
	int count = rs.getInt(1);
	if(count>0) {
		pw.print("true");
	}else{
		pw.print("false");
	}
%>