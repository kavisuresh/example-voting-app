<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Apples vs Oranges!</title>
<link rel='stylesheet' href="style.css" /> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
</head>
<body>
<%@ page import = "java.sql.*" %>
<%@ page import = "org.json.JSONObject" %>
<%@ page import = "com.ibm.websphere.objectgrid.ClientClusterContext" %>
<%@ page import = "com.ibm.websphere.objectgrid.ConnectException" %>
<%@ page import = "com.ibm.websphere.objectgrid.ObjectGridRuntimeException" %>
<%@ page import = "com.ibm.websphere.objectgrid.ObjectGrid" %>
<%@ page import = "com.ibm.websphere.objectgrid.ObjectGridException" %>
<%@ page import = "com.ibm.websphere.objectgrid.ObjectGridManager" %>
<%@ page import = "com.ibm.websphere.objectgrid.ObjectGridManagerFactory" %>
<%@ page import = "com.ibm.websphere.objectgrid.ObjectMap" %>
<%@ page import = "com.ibm.websphere.objectgrid.Session" %>

<%! ObjectGrid og; %>
<%! Session sess; %>
<%! ObjectMap map; %>

<%!
public void jspInit(){
   try{
        og = getObjectGrid("wxs:2809", "Grid");
        sess = og.getSession();
        map = sess.getMap("Votes");
   }catch (ConnectException e) {
      e.printStackTrace();
   }catch (ObjectGridException e) {
      e.printStackTrace();
  }
}
%>
<%
  String voter_id = request.getSession().getId();
  String vote= request.getParameter("vote");
 
  String vote1 ="";
  if (vote.equals("a"))
  { 
	  vote1 = "Apples";
  }
  else if (vote.equals("b"))
  {
	  
	  vote1 = "Oranges";
  }
  JSONObject obj = new JSONObject();
  obj.put("vote",vote);
  obj.put("voter_id",voter_id);
  try{
  map.upsert("votes", obj.toString()); 
  } catch (ObjectGridException e) {
      e.printStackTrace();
  }
%>
<%!
  static protected ObjectGrid getObjectGrid(String csEndpoints, String gridName) throws ConnectException {

  ObjectGrid result = null;         
        
  ObjectGridManager ogm = ObjectGridManagerFactory.getObjectGridManager();
  
  ClientClusterContext ccc = null;
  while (true) {
        try {
            ccc = ogm.connect(csEndpoints,     null, null);
            break;
  } catch (ConnectException e) {
        System.err.println("Failed to connect to wxs  - retrying");
        try {
            Thread.sleep(3000);                 //1000 milliseconds is one second.
        } catch(InterruptedException ex) {
            Thread.currentThread().interrupt();
        }
  }
  }
  while (true) {
        try {
            result = ogm.getObjectGrid(ccc, gridName);
            break;
        } catch (ObjectGridRuntimeException e) {
        System.err.println("Failed to connect to GRID  - retrying");
        try {
            Thread.sleep(3000);                 //1000 milliseconds is one second.
        } catch(InterruptedException ex) {
            Thread.currentThread().interrupt();
        }
        }
  }
        
  return result;
}
%>
<div id="content-container">
      <div id="content-container-center">
        <h3>Apples vs Oranges!</h3>
        <form id="choice" name='form' method="POST" action="VotingApp.jsp">
        <%  if (vote.equals("a")){ %>
          <button id="a" type="submit" name="vote" class="a" value="a" disabled><i class="fa fa-check-circle"></i>Apples</button>
          <button id="b" type="submit" name="vote" class="b" value="b">Oranges</button>
        <% } else if(vote.equals("b")) { %>
          <button id="a" type="submit" name="vote" class="a" value="a">Apples</button>
          <button id="b" type="submit" name="vote" class="b" value="b" disabled><i class="fa fa-check-circle"></i>Oranges</button>
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
