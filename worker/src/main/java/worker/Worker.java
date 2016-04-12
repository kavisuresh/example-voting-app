package worker;

import java.sql.*;
import org.json.JSONObject;
import com.ibm.websphere.objectgrid.ClientClusterContext;
import com.ibm.websphere.objectgrid.ConnectException;
import com.ibm.websphere.objectgrid.ObjectGrid;
import com.ibm.websphere.objectgrid.ObjectGridException;
import com.ibm.websphere.objectgrid.ObjectGridManager;
import com.ibm.websphere.objectgrid.ObjectGridManagerFactory;
import com.ibm.websphere.objectgrid.ObjectGridRuntimeException;
import com.ibm.websphere.objectgrid.ObjectMap;
import com.ibm.websphere.objectgrid.Session;
import com.ibm.websphere.objectgrid.plugins.TransactionCallbackException;

class Worker {
  public static void main(String[] args) {
    try {
      ObjectGrid og = getObjectGrid("wxs:2809", "Grid");
      Connection dbConn = connectToDB("db");

      System.err.println("Watching vote queue");

      Session sess = og.getSession();
      ObjectMap map = sess.getMap("Votes");

      while (true) {
        if (map.containsKey("votes"))
        {
        Object voteJSON = map.remove("votes");
        JSONObject voteData = new JSONObject(voteJSON.toString());
        String voterID = voteData.getString("voter_id");
        String vote = voteData.getString("vote");

        System.err.printf("Processing vote for '%s' by '%s'\n", vote, voterID);
        updateVote(dbConn, voterID, vote);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
      System.exit(1);
    } catch (ConnectException e) {
      e.printStackTrace();
    } catch (TransactionCallbackException e) {
      e.printStackTrace();
    } catch (ObjectGridException e) {
      e.printStackTrace();
    } 
  }

  static void updateVote(Connection dbConn, String voterID, String vote) throws SQLException {
    PreparedStatement insert = dbConn.prepareStatement(
      "INSERT INTO votes (id, vote) VALUES (?, ?)");
    insert.setString(1, voterID);
    insert.setString(2, vote);

    try {
      insert.executeUpdate();
    } catch (SQLException e) {
      PreparedStatement update = dbConn.prepareStatement(
        "UPDATE votes SET vote = ? WHERE id = ?");
      update.setString(1, vote);
      update.setString(2, voterID);
      update.executeUpdate();
    }
  }

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
        sleep(1000);
        }
       }
       while (true) {
        try {
            result = ogm.getObjectGrid(ccc, gridName);
            break;
        } catch (ObjectGridRuntimeException e) {
        System.err.println("Failed to connect to GRID  - retrying");
        sleep(1000);
        }
       }

        return result;
  }
  static Connection connectToDB(String host) throws SQLException {
    Connection conn = null;

    try {

      Class.forName("com.ibm.db2.jcc.DB2Driver");
      String url = "jdbc:db2://"+ host +":50000/DB2";

      while (conn == null) {
        try {
          conn = DriverManager.getConnection(url, "db2inst1", "db2inst1");
        } catch (SQLException e) {
          System.err.println("Failed to connect to db - retrying");
          sleep(1000);
        }
      }

      PreparedStatement st = conn.prepareStatement(
        "CREATE TABLE votes (id VARCHAR(255) NOT NULL UNIQUE, vote VARCHAR(255) NOT NULL)");
      st.executeUpdate();

    }catch (SQLException e) {
      System.err.println("Table Already exists , so not recreating ");

    } catch (ClassNotFoundException e) {
      e.printStackTrace();
      System.exit(1);
    }

    return conn;
  }

  static void sleep(long duration) {
    try {
      Thread.sleep(duration);
    } catch (InterruptedException e) {
      System.exit(1);
    }
  }
}
