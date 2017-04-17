<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*, java.util.Date, JavaBean.*, java.util.*"%>
<%
 	Connection conn = DB.getConn();
 	int articleCount = 4;
 	List<Article> articles = new ArrayList<Article>();
 	Statement state = DB.createState(conn);
 	int pageNum = 0;
 	String pagenum = request.getParameter("pagenum");
 	if(pagenum==null) {
 		pageNum = 1;
 	}else {
 		pageNum = Integer.parseInt(pagenum);
 	}
 	request.setCharacterEncoding("utf-8");
 	String username = (String)session.getValue("username");
 	if(username==null) {
 		response.sendRedirect("article.jsp");
 	}
 	ResultSet rs = null;
 	String count = "select count(*) from bbs where pid = 0";
 	rs = DB.executeQuery(state, count);
 	rs.next();
 	int sumArticles = rs.getInt(1);
 	String sql = "select * from bbs where pid = 0 order by id desc limit "+(pageNum-1)*articleCount+","+articleCount;
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
	int pageCount = (int)Math.ceil((double)sumArticles/(double)articleCount);	
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>article</title>
	<script type="text/javascript" src="CKEditor/ckeditor.js"></script>
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
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
	            	<input id='searchContentT' type="text" class="form-control" style="width:320px" placeholder="搜索问题、话题或人">
	                <span class="input-group-addon"><a id='searchT' href="#"><span class="glyphicon glyphicon-search"></span></a></span>
	            </div>
        	</form>
			<ul class='nav navbar-nav'>
    			<li class="active"><a href="#"><span class="glyphicon glyphicon-th-list"></span>发现</a></li>
    			<li><a href="#about"><span class="glyphicon glyphicon-comment"></span>话题</a></li>
    			<li><a href="#publishTopic"><span class="glyphicon glyphicon-edit"></span>发帖</a></li>
    		</ul>
    		<span class="pull-right">
    			<a class='btn btn-primary navbar-btn' href='personalData.jsp'><%=username%></a>
    			<a class='btn btn-info navbar-btn' href="article.jsp">退出</a>
    		</span>
		</div>
	</nav>
	<div class='container'>
		<ul class='nav nav-tabs'>
	 		<li class='active'><a href='#a' data-toggle='tab'>最新</a></li>
	 		<li><a href='#b' data-toggle='tab'>热门</a></li>
	 		<li><a href='#c' data-toggle='tab'>推荐</a></li>
 		</ul>
	 	<ul class='tab-content'>
	 		<li id='a' class='tab-pane fade in active'>
	 			<div id="topicList" class="list-group">
	 				<% 
	 					Iterator<Article> i = articles.iterator();
	 					while(i.hasNext()) {
	 						Article a = i.next();
	 						String author = a.getAuthor();
	 						sql = "select image_path from user where user_name='"+author+ "'";
	 						rs = DB.executeQuery(state, sql);
	 						rs.next();
	 						String header_path = rs.getString(1);
	 				%>
					<div class='row list-group-item'>
						<div class='col-lg-2 text-center'><img class='img-rounded headPic' src="<%=header_path%>" alt="头像"><br/><span id="user_name"><%=a.getAuthor()%></span></div>
						<div class='col-lg-8'><a href="contentT.jsp?id=<%=a.getId()%>"><%=a.getTitle()%></a></div>
						<div class='col-lg-2'><a class='btn btn-primary' href="contentT.jsp?id=<%=a.getId()%>">回复</a></div>
					</div>
					<% }
						rs.close();
						DB.closeAll(conn, state);
					%>
				</div>
	 		</li>
	 		<li id='b' class='tab-pane'>三四</li>
	 		<li id='c' class='tab-pane'>五六</li>
	 	</ul>
	 	<form id="publishTopic" action="addTopic.jsp" method="post">
	 		<label>话题名:</label><input name="topicTitle" type="text"/>
            <textarea name="topicContent" id="editor1" rows="10" cols="80">
            </textarea>
            <script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace( 'editor1' );
            </script>
            <input class="btn btn-danger" type="submit" value="发表新话题"/>
        </form>
        <nav aria-label="Page navigation" class="text-center">
  			<ul class="pagination">
    		<li>
    		<% 
    			if(pageNum==1) {
    		%>
	    		<a href="articleT.jsp?pagenum=<%=pageNum%>" aria-label="Previous">
	    			<span aria-hidden="true">&laquo;</span>
	    		</a>
	    	<%}else{%>	
	    		<a href="articleT.jsp?pagenum=<%=pageNum-1%>" aria-label="Previous">
	    			<span aria-hidden="true">&laquo;</span>
	    		</a>
	    	<%}%>	
    		</li>
    		<%for(int j=1;j<=pageCount;j++) {
    			if(j==pageNum) {
    			out.println("<li class='active'><a href='articleT.jsp?pagenum="+j+"'>"+j+"</a></li>");
    			}else {
    		%>
    		<li><a href='articleT.jsp?pagenum=<%=j%>'><%=j%></a></li>
    		<%}}%>
		    <li>
		    <%
		    	if(pageNum!=pageCount) { 
		    %>
		      <a href='articleT.jsp?pagenum=<%=pageNum+1%>' aria-label="Next">
		          <span aria-hidden="true">&raquo;</span>
		      </a>
		     <%
		     	}else {
		      %>
		      <a href='articleT.jsp?pagenum=<%=pageNum%>' aria-label="Next">
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