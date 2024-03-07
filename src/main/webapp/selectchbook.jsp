<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%!
	String resultOk = null;
	int getrow = 0;
%>

<%-- 유저 찾기 --%>
<%
	String bookid = request.getParameter("bookid");
	String bookname = request.getParameter("bookname");
	//System.out.println(bookname);
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String resultid = null;
	String resultname = null;
	String resultHP = null;

	try {
		getrow = 0;
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = "select * from check_out where book_id = ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, bookid);
		rs = pstmt.executeQuery();
		

		if(rs.next()){
			resultOk = "N";
		}
		else {
			sql = "select * from reservation where book_name = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bookname);
			rs = pstmt.executeQuery();
			if(rs.next()){
				resultOk = "N";
			} else {
				resultOk = "Y";
			}
		}		 
		bookname = bookname.replaceAll(" ", "&nbsp;");
		con.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage()+"<br>");
		e.printStackTrace();
	}
%>
<legend>도서 정보</legend>
<label>번호<input type="text" name="bookid" value=<%=bookid%> readonly></label>
<label>이름<input type="text" name="bookname" value=<%=bookname%> readonly></label>
<label>대출 가능 여부<input type="text" name="bookOk" value=<%=resultOk%> readonly></label>
</body>
</html>