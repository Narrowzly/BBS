<%@page language="java" contentType="text/html; charset=utf8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*, java.util.Date, JavaBean.*, java.util.*"%>
<%
 	Connection conn = DB.getConn();
 	List<Article> articles = new ArrayList<Article>();
 	Statement state = DB.createState(conn);
 	request.setCharacterEncoding("UTF-8");
 	String id = request.getParameter("id");
 	String author = (String)session.getValue("username");
 	if(author==null) {
 		response.sendRedirect("article.jsp");
 	}
 	String title = null;
 	String content = null;
 	int replyCount = 5;
 	int pageNum = 0;
 	int sumReplies =0;
 	String pagenum = request.getParameter("pagenum");
 	if(pagenum==null) {
 		pageNum = 1;
 	}else {
 		pageNum = Integer.parseInt(pagenum);
 	}
	String sql1 = "select * from bbs where id =" + id;
	String count = "select count(*) from bbs where pid="+id;  
 	String sql = "select * from bbs where pid ="+id+" limit "+(pageNum-1)*replyCount+","+replyCount;
 	ResultSet rs = null;
 	rs = DB.executeQuery(state, count);
 	rs.next();
 	sumReplies = rs.getInt(1); 
	rs = DB.executeQuery(state, sql1);
	rs.next();
	title = rs.getString("title");
	content = rs.getString("content");
 	rs = DB.executeQuery(state, sql);
	try {
		while(rs.next()) {
			Article a = new Article();
			a.initArticle(rs);
			articles.add(a);
		}
	}catch(SQLException e) {
		e.printStackTrace();
	}
	rs.close();
	DB.closeAll(conn,state);
	int pageCount = (int)Math.ceil((double)sumReplies/(double)replyCount);
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>content</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<script type="text/javascript" src='CKEditor/ckeditor.js'></script>
<style type="text/css" media="screen">
	.tab-content{ 
		border:1px #ddd solid; 
		border-top:none; padding:50px; 
		border-radius:0 0 5px 5px;
	}
	.headPic {
		width: 70px;
		height: 70px;
	}
	.list-group-item {
		border-left:none;
		border-right:none;
	}
</style>
</head>
<body>
	<nav id="myNavbar" class="navbar navbar-default navbar-static-top">
		<div class='container'>	
			<div class='navbar-header'>
				<a href="" class='navbar-brand'>你最可爱了</a>
			</div>
			<form class="navbar-form navbar-left">
	        	<div class="input-group">
	            	<input id="searchContentT" type="text" class="form-control" style="width:320px" placeholder="搜索问题、话题或人">
	                <span class="input-group-addon"><a id="searchT" href="#"><span class="glyphicon glyphicon-search"></span></a></span>
	            </div>
        	</form>
			<ul class='nav navbar-nav'>
    			<li class="active"><a href="#"><span class="glyphicon glyphicon-th-list"></span>发现</a></li>
    			<li><a href="#"><span class="glyphicon glyphicon-comment"></span>话题</a></li>
    			<li><a href="articleT.jsp"><span class="glyphicon glyphicon-edit"></span>发帖</a></li>
    		</ul>
    		<span class="pull-right">
    			<a class='btn btn-info navbar-btn' href="personalData.jsp"><%=author%></a>
    			<a class='btn btn-success navbar-btn' href="article.jsp">退出</a>
    		</span>
		</div>
	</nav>
	<div class='container'>
		<div class="panel panel-default">
				<!-- Default panel contents -->
			<div class="panel-heading"><%=title%></div>
			<div class="panel-body">
				<p><%=content%></p>
			</div>
			<!-- Table -->
			<table class="table">
				<thead>
					<td class='col-lg-3'>用户</td>
					<td class='col-lg-8'>回复</td>
					<td class='col-lg-1'>楼层</td>
				</thead>
				<tbody>
				<%
					Iterator<Article> i = articles.iterator();
					int floorNum=(pageNum-1)*replyCount+1;
					while(i.hasNext()) {
					Article a = i.next();
				%>
					<tr>
						<td><%=a.getAuthor()%></td>
						<td><%=a.getContent()%></td>
						<td><%=floorNum%>楼</td>
					</tr>
				<%floorNum++;}%>	
				</tbody>
			</table>
			<form action="reply.jsp?id=<%=id%>" method="post">
	            <textarea name="titleResponse" id="editor1" rows="10" cols="80">
	            </textarea>
	            <script>
	                // Replace the <textarea id="editor1"> with a CKEditor
	                // instance, using default configuration.
	                CKEDITOR.replace( 'editor1' );
	            </script>
	            <input class="btn btn-danger" type="submit" value="回复"/>
        	</form>
		</div>
		<nav aria-label="Page navigation" class="text-center">
  			<ul class="pagination">
    		<li>
    		<% 
    			if(pageNum==1) {
    		%>
	    		<a href="contentT.jsp?pagenum=<%=pageNum%>&id=<%=id%>" aria-label="Previous">
	    			<span aria-hidden="true">&laquo;</span>
	    		</a>
	    	<%}else{%>	
	    		<a href="contentT.jsp?pagenum=<%=pageNum-1%>&id=<%=id%>" aria-label="Previous">
	    			<span aria-hidden="true">&laquo;</span>
	    		</a>
	    	<%}%>	
    		</li>
    		<%for(int j=1;j<=pageCount;j++) {
    			if(j==pageNum) {
    			out.println("<li class='active'><a href='contentT.jsp?pagenum="+j+"&id="+id+"'>"+j+"</a></li>");
    			}else {
    		%>
    		<li><a href='contentT.jsp?pagenum=<%=j%>&id=<%=id%>'><%=j%></a></li>
    		<%}}%>
		    <li>
		    <%
		    	if(pageNum!=pageCount) { 
		    %>
		      <a href='contentT.jsp?pagenum=<%=pageNum+1%>&id=<%=id%>' aria-label="Next">
		          <span aria-hidden="true">&raquo;</span>
		      </a>
		     <%
		     	}else {
		      %>
		      <a href='contentT.jsp?pagenum=<%=pageNum%>&id=<%=id%>' aria-label="Next">
		          <span aria-hidden="true">&raquo;</span>
		      </a>
		      <% 
		      	}
		      %>
		    </li>
		  </ul>
		</nav>
	</div>
</body>
<script type="text/javascript" src='js/jquery.js'></script>
<script type="text/javascript" src='js/bootstrap.min.js'></script>
<script type="text/javascript" src='js/search.js'></script>
</html>