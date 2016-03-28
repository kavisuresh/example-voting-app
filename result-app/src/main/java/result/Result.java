package result;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.annotation.Resource;
import javax.sql.DataSource;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Websocket Endpoint implementation class Result */

@ServerEndpoint("/result")

public class Result {

	Connection conn= null;
	/* Notified when a new web socket session is open. */
	@OnOpen
	public void onOpen(Session session){
		System.out.println(session.getId() + " has opened a connection"); 
		try {
			session.getBasicRemote().sendText("Connection Established");

			try {
				conn=connectToDB("db");
				Statement stmt = conn.createStatement();
				while(true)
				{
					ResultSet result = stmt.executeQuery("SELECT vote, COUNT(id) AS count FROM votes GROUP BY vote");       

					JSONObject obj = new JSONObject();
					int i =1;
					while (result.next())
					{
						try {
							obj.put("Vote"+i+"", result.getString(1));
							obj.put("Count"+i+"", result.getString(2));
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

						i++;
					}

					session.getBasicRemote().sendText(obj.toString());
					try {
						Thread.sleep(3000);                 //1000 milliseconds is one second.
					} catch(InterruptedException ex) {
						Thread.currentThread().interrupt();
					}
				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}




		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

	/* Notified when the client sends message to server */
	@OnMessage
	public void onMessage(String message, Session session){
		System.out.println("Message from " + session.getId() + ": " + message);
		try {
			session.getBasicRemote().sendText(message);
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

	/* notified when the user closes connection */
	@OnClose
	public void onClose(Session session){
		System.out.println("Session " +session.getId()+" has ended");
	}


	@Resource(name = "jdbc/db2")
	DataSource ds1;
	Connection connectToDB(String host) throws SQLException {
		Connection conn = null;

		while (conn == null) {
			try {
				conn = ds1.getConnection();
			} catch (SQLException e) {
				System.err.println("Failed to connect to db - retrying");
				try {
					Thread.sleep(3000);                 //1000 milliseconds is one second.
				} catch(InterruptedException ex) {
					Thread.currentThread().interrupt();
				}
			}
		}

		return conn;
	}

}
