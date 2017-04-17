<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*, java.util.Date, JavaBean.*, java.util.*"%>
<%
 	Connection conn = DB.getConn();
 	int articleCount = 4;
 	List<Article> articles = new ArrayList<Article>();
 	Statement state = DB.createState(conn);
 	int pageNum = 0;
 	String pagenum = request.getParameter("pagenum");
 	String problem = request.getParameter("problem");
 	String username = (String)session.getValue("username");
 	if(username==null) {
 		response.sendRedirect("article.jsp");
 	}
 	if(pagenum==null) {
 		pageNum = 1;
 	}else {
 		pageNum = Integer.parseInt(pagenum);
 	}
 	ResultSet rs = null;
 	String count = "select count(*) from bbs where title like '%" + problem + "%'";
 	rs = DB.executeQuery(state, count);
 	rs.next();
 	int sumArticles = rs.getInt(1);
 	String sql = "select * from bbs where title like '%" + problem + "%' order by id desc limit " + (pageNum-1)*articleCount+","+articleCount;
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
<title>search</title>
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
	            	<input id='searchContent' type="text" class="form-control" style="width:320px" placeholder="搜索问题、话题或人">
	                <span class="input-group-addon"><a id='search' href="#"><span class="glyphicon glyphicon-search"></span></a></span>
	            </div>
        	</form>
			<ul class='nav navbar-nav'>
    			<li class="active"><a href="#"><span class="glyphicon glyphicon-th-list"></span>发现</a></li>
    			<li><a href="#about"><span class="glyphicon glyphicon-comment"></span>话题</a></li>
    			<li><a href="#publishTopic"><span class="glyphicon glyphicon-edit"></span>发帖</a></li>
    		</ul>
    		<span class="pull-right">
    			<a class='btn btn-info navbar-btn' href="personalData.jsp"><%=username%></a>
    			<a class='btn btn-success navbar-btn' href="article.jsp">退出</a>
    		</span>
		</div>
	</nav>
	<div id="register" class="modal fade"> 
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header"> 
	            	<a class="close" data-dismiss="modal">×</a> 
	            	<h3>只有尊贵的人才能入住我们论坛</h3> 
    			</div> 
		        <div class="modal-body"> 
		            <form id="register_form" action="register.jsp" method="post">
		            	<div class="form-group">
		            		<label>用户名</label>
		            		<input id='register_name' name="register_name" type="text" placeholder="建议取个好听的名字" class="form-control"/>
		            		<div id="userName_reminder" class='alert hidden'></div>
		            		<label>密码</label>
		            		<input name="register_password" type="password" placeholder="千万不要告诉陌生人" class="form-control"/>
		            	</div>
		            </form>
		        </div> 
		        <div class="modal-footer"> 
		            <button id="register_button" class="btn btn-primary">注册</button> 
		            <button class="btn btn-default" data-dismiss="modal">关闭</button> 
		        </div> 
			</div>
		</div>
	</div>
	<div id="login" class="modal fade"> 
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header"> 
	            	<a class="close" data-dismiss="modal">×</a> 
	            	<h3>请登录</h3> 
    			</div> 
		        <div class="modal-body"> 
		            <form id="login_form" action="login.jsp" method="post">
		            	<div class="form-group">
		            		<label>用户名</label>
		            		<input id='login_name' name="login_name" type="text" placeholder="邮箱或者您的常用名" class="form-control"/>
		            		<label>密码</label>
		            		<input name="login_password" id="login_password" type="password" placeholder="千万不要告诉陌生人" class="form-control"/>
		            	</div>
		            </form>
		        </div> 
		        <div class="modal-footer"> 
		            <button id="login_button" class="btn btn-primary">登录</button> 
		            <button class="btn btn-default" data-dismiss="modal">关闭</button> 
		        </div> 
			</div>
		</div>
	</div>
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
						<div class='col-lg-2 text-center'><img class='img-rounded headPic' src="<%=header_path %>" alt="头像"><br/><span id="user_name"><%=a.getAuthor() %></span></div>
						<div class='col-lg-8'><a href="content.jsp?id=<%=a.getId()%>"><%=a.getTitle()%></a></div>
						<div class='col-lg-2'><a class='btn btn-primary' href="content.jsp?id=<%=a.getId()%>">回复</a></div>
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
	    		<a href="article.jsp?pagenum=<%=pageNum%>" aria-label="Previous">
	    			<span aria-hidden="true">&laquo;</span>
	    		</a>
	    	<%}else{%>	
	    		<a href="article.jsp?pagenum=<%=pageNum-1%>" aria-label="Previous">
	    			<span aria-hidden="true">&laquo;</span>
	    		</a>
	    	<%}%>	
    		</li>
    		<%for(int j=1;j<=pageCount;j++) {
    			if(j==pageNum) {
    			out.println("<li class='active'><a href='article.jsp?pagenum="+j+"'>"+j+"</a></li>");
    			}else {
    		%>
    		<li><a href='article.jsp?pagenum=<%=j%>'><%=j%></a></li>
    		<%}}%>
		    <li>
		    <%
		    	if(pageNum!=pageCount) { 
		    %>
		      <a href='article.jsp?pagenum=<%=pageNum+1%>' aria-label="Next">
		          <span aria-hidden="true">&raquo;</span>
		      </a>
		     <%
		     	}else {
		      %>
		      <a href='article.jsp?pagenum=<%=pageNum%>' aria-label="Next">
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
<script type="text/javascript" src="js/register.js"></script>
<script type="text/javascript" src='js/login.js'></script>
<script type="text/javascript" src='js/search.js'></script>
</html>