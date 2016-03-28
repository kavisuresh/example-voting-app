<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Coke vs Pepsi!</title>
<link rel='stylesheet' href="style.css" /> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
</head>
<body>
<%@ page import = "java.sql.*" %>
<%@ page import = "redis.clients.jedis.Jedis" %>
<%@ page import = "redis.clients.jedis.exceptions.JedisConnectionException" %>
<%@ page import = "org.json.JSONObject" %>

<%! Jedis jedis; %>
<%!
public void jspInit(){
	jedis =connectToRedis("redis");
}
%>
<%
  String voter_id = request.getSession().getId();
  String vote= request.getParameter("vote");
 
  String vote1 ="";
  if (vote.equals("a"))
  { 
	  vote1 = "Coke";
  }
  else if (vote.equals("b"))
  {
	  
	  vote1 = "Pepsi";
  }
  JSONObject obj = new JSONObject();
  obj.put("vote",vote);
  obj.put("voter_id",voter_id);
  jedis.rpush("votes", obj.toString()); 
%>
<%!
    static Jedis connectToRedis(String host) {
    Jedis conn = new Jedis(host);

    while (true) {
      try {
        conn.keys("*");
        break;
      } catch (JedisConnectionException e) {
        System.err.println("Failed to connect to redis - retrying");
        try {
    	    Thread.sleep(3000);                 //1000 milliseconds is one second.
    	} catch(InterruptedException ex) {
    	    Thread.currentThread().interrupt();
    	}
      }
    }
   
    System.out.println("Connected to redis");
    return conn;
  }
%>
<div id="content-container">
      <div id="content-container-center">
        <h3>Coke vs Pepsi!</h3>
        <form id="choice" name='form' method="POST" action="VotingApp.jsp">
        <%  if (vote.equals("a")){ %>
          <button id="a" type="submit" name="vote" class="a" value="a" disabled><i class="fa fa-check-circle"></i>Coke</button>
          <button id="b" type="submit" name="vote" class="b" value="b">Pepsi</button>
        <% } else if(vote.equals("b")) { %>
          <button id="a" type="submit" name="vote" class="a" value="a">Coke</button>
          <button id="b" type="submit" name="vote" class="b" value="b" disabled><i class="fa fa-check-circle"></i>Pepsi</button>
        <% } %>  
        </form>   
        <div id="tip">
          (Tip: you can change your vote)
        </div>
        <div id="hostname">
          Vote processed by <% out.println(voter_id);%>
        </div>
      </div>
   </div> 
</body>
</html>
