package repository;


import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.datastax.driver.core.ResultSet;
import com.datastax.driver.core.Row;
import com.datastax.driver.core.Session;

import Cassandra.CryptoStats;
import Model.GlobalStat;

public class CryptoStatsRepository {

    private static final String TABLE_NAME = "Stats";// Table name

    private static final String TABLE_NAME_BY_TITLE = TABLE_NAME + "ByTitle";

    private Session session;

    public CryptoStatsRepository(Session session) {
        this.session = session;
    }

    /**
     * Creates the books table.
     */
    public void createTableStats() {
        StringBuilder sb = new StringBuilder("CREATE TABLE IF NOT EXISTS ")
        		.append(TABLE_NAME)
        		.append("(")
        		.append("name text  PRIMARY KEY, ")
        		.append("rsi_1h double, ")
        		.append("rsi_24h double, ")
        		.append("rsi_7d double, ")
        		.append("rsi_annualise double, ")
        		.append("tauxMarche double ")
        		.append(");");
       // System.out.println(sb);
        final String query = sb.toString();
        session.execute(query);
    }
    //ADDED
    public void createTableGloablStats() {
        StringBuilder sb = new StringBuilder("CREATE TABLE IF NOT EXISTS ")
        		.append("GlobalStats")
        		.append("(")
        		.append("name text  PRIMARY KEY, ")
        		.append("moyenne double, ")
        		.append("ecart_type double,")
        		.append("evolution text,")
        		.append("volatilite text)")
        		;
       // System.out.println(sb);
        final String query = sb.toString();
        session.execute(query);
    }
    //TOADD
    public void createTableByName(String name ){
    	  StringBuilder sb = new StringBuilder("CREATE TABLE IF NOT EXISTS ")
          		.append(name)
          		.append("(")
          		.append("id text  PRIMARY KEY, ")
          		.append("name text, ")
          		.append("time_insert timestamp,")
          		.append("rsi_1h double, ")
          		.append("rsi_24h double, ")
          		.append("rsi_7d double, ")
          		.append("rsi_annualise double, ")
          		.append("tauxMarche double ")
          		.append(");");
         // System.out.println(sb);
          final String query = sb.toString();
          System.out.println(query);
          session.execute(query);
    }

    /**
     * Creates the books table.
     */
   /* public void createTableBooksByTitle() {
        StringBuilder sb = new StringBuilder("CREATE TABLE IF NOT EXISTS ").append(TABLE_NAME_BY_TITLE).append("(").append("id uuid, ").append("name text,").append("PRIMARY KEY (name, id));");

        final String query = sb.toString();
        session.execute(query);
    }*

    /**
     * Alters the table books and adds an extra column.
     */
    public void alterTablebooks(String columnName, String columnType) {
        StringBuilder sb = new StringBuilder("ALTER TABLE ")
        		.append(TABLE_NAME)
        		.append(" ADD ")
        		.append(columnName)
        		.append(" ")
        		.append(columnType)
        		.append(";");

        final String query = sb.toString();
        session.execute(query);
    }

    /**
     * Insert a row in the table stats. 
     * 
     * @param book
     */
    public void insertStat(CryptoStats stat) {
    	try {
        StringBuilder sb = new StringBuilder("INSERT INTO ")
        		.append(TABLE_NAME)
        		.append("(name, rsi_1h, rsi_24h, rsi_7d, rsi_annualise, tauxMarche) ")
        		.append("VALUES ('")
        		.append(stat.getName())
        		.append("', ")
                .append(stat.getRsi_1h())
                .append(", ")
                .append(stat.getRsi_24h())
                .append(", ")
                .append(stat.getRsi_7d())
                .append(", ")
                .append(stat.getRsi_annualise())
                .append(", ")
                .append(stat.getTauxMarche())
                .append(")");

        final String query = sb.toString();
        session.execute(query);
    	}catch(Exception e)
    	{
    		System.out.println(e);
    		e.printStackTrace();
    	}
    }
    public void insertGlobalStat(GlobalStat stat) {
    	try {
        StringBuilder sb = new StringBuilder("INSERT INTO ")
        		.append("GlobalStats")
        		.append("(name, moyenne, ecart_type, evolution , volatilite) ")
        		.append("VALUES ('")
        		.append(stat.getName())
        		.append("', ")
                .append(stat.getMoyenne())
                .append(", ")
                .append(stat.getEcart_type())
                .append(", '")
                .append(stat.getEvolution())
                .append("', '")
                .append(stat.getVolatilite())
                .append("')");

        final String query = sb.toString();
        session.execute(query);
    	}catch(Exception e)
    	{
    		System.out.println(e);
    		e.printStackTrace();
    	}
    }

  

    /**
     * Insert a coin into two identical tables using a batch query.
     * 
     * @param coin
     */
    /*public void insertCoinBatch(Coin coin) {
        StringBuilder sb = new StringBuilder("BEGIN BATCH ").append("INSERT INTO ").append(TABLE_NAME).append("(id, name, marketcap) ").append("VALUES (").append(coin.getId()).append(", '").append(coin.getName()).append("', '").append(coin.getMarketcap())
                .append("');").append("INSERT INTO ").append(TABLE_NAME_BY_TITLE).append("(id, name) ").append("VALUES (").append(coin.getId()).append(", '").append(coin.getName()).append("');")
                .append("APPLY BATCH;");

        final String query = sb.toString();
        session.execute(query);
    }*/

    /**
     * Select coin by id.
     * 
     * @return
     */
    public CryptoStats selectByCryptoName(String name) {
        StringBuilder sb = new StringBuilder("SELECT * FROM ").append(TABLE_NAME).append(" WHERE name = '").append(name).append("';");

        final String query = sb.toString();

        ResultSet rs = session.execute(query);

        List<CryptoStats> list_cryptoStats = new ArrayList<CryptoStats>();

        for (Row r : rs) {
            //
        	CryptoStats stat = new CryptoStats(
        			r.getString("name")
        			, r.getDouble("rsi_1h")
        			, r.getDouble("rsi_24h")
        			, r.getDouble("rsi_7d")
        			, r.getDouble("rsi_annualise")
        			, r.getDouble("tauxMarche"));
            list_cryptoStats.add(stat);
        }

        return list_cryptoStats.get(0);
    }

    /**
     * Select all coins from coins
     * 
     * @return
     */
    public List<CryptoStats> selectAll() {
        StringBuilder sb = new StringBuilder("SELECT * FROM ").append(TABLE_NAME);

        final String query = sb.toString();
        ResultSet rs = session.execute(query);

        List<CryptoStats> list_cryptoStats = new ArrayList<CryptoStats>();

        for (Row r : rs) {
        	CryptoStats stat = new CryptoStats( r.getString("name")
        			, r.getDouble("rsi_1h")
        			, r.getDouble("rsi_24h")
        			, r.getDouble("rsi_7d")
        			, r.getDouble("rsi_annualise")
        			, r.getDouble("tauxMarche"));
        	
          
        	list_cryptoStats.add(stat);
        }
        return list_cryptoStats;
    }

   /* public void deletebookByTitle(String name) {
        StringBuilder sb = new StringBuilder("DELETE FROM ").append(TABLE_NAME_BY_TITLE).append(" WHERE name = '").append(name).append("';");

        final String query = sb.toString();
        session.execute(query);
    }*/
   /* public List<Coin> selectAllBookByTitle() {
        StringBuilder sb = new StringBuilder("SELECT * FROM ").append(TABLE_NAME_BY_TITLE);

        final String query = sb.toString();
        ResultSet rs = session.execute(query);

        List<Coin> coins = new ArrayList<Coin>();

        for (Row r : rs) {
            Coin coin = new Coin(r.getUUID("id"), r.getString("name"),  null);
            coins.add(coin);
        }
        return coins;
    }*/
    /*
     * Delete table.
     * 
     * @param tableName the name of the table to delete.
     */
    public void deleteTable(String tableName) {
        StringBuilder sb = new StringBuilder("DROP TABLE IF EXISTS ").append(tableName);

        final String query = sb.toString();
        session.execute(query);
    }
   
    public void deleteAll(String tableName) {
        StringBuilder sb = new StringBuilder("TRUNCATE ").append(tableName);

        final String query = sb.toString();
        session.execute(query);
    }
    public void deleteAllStats() {
        deleteAll(TABLE_NAME);
    }
    //ADDED
    public void deleteAllGlobalStats() {
        deleteAll("GlobalStats");
    }
    
    
  //TOADD
    public void insertStatIntoCrypto(CryptoStats stat, String crypto) {
     	try {
        	Timestamp current_time = new Timestamp(System.currentTimeMillis());
        	String name = stat.getName();
        	String id = name+"_"+current_time;
            StringBuilder sb = new StringBuilder("INSERT INTO ")
            		.append(crypto)
            		.append("(id, name, time_insert, rsi_1h, rsi_24h, rsi_7d, rsi_annualise, tauxMarche) ")
            		.append("VALUES ('")
            		.append(id)
            		.append("', '")
            		.append(stat.getName())
            		.append("', '")
            		.append(current_time)
            		.append("', ")
                    .append(stat.getRsi_1h())
                    .append(", ")
                    .append(stat.getRsi_24h())
                    .append(", ")
                    .append(stat.getRsi_7d())
                    .append(", ")
                    .append(stat.getRsi_annualise())
                    .append(", ")
                    .append(stat.getTauxMarche())
                    .append(")");

            		/*
            		.append("(id, name, rsi_1h, rsi_24h, rsi_7d, rsi_annualise, tauxMarche) ")
            		.append("VALUES (")
            		.append(stat.getId())
            		.append(", '")
            		.append(stat.getName())
            		.append("', ")
            		.append(stat.getRsi_1h())
            		.append(", ")
            		.append(stat.getRsi_24h())
            		.append(", ")
            		.append(stat.getRsi_7d())
            		.append(", ")
            		.append(stat.getRsi_annualise())
            		.append(", ")
            		.append(stat.getTauxMarche())
            		//.append("', '")
            		.append(");");
            		*/
           System.out.println(sb);
            final String query = sb.toString();
            session.execute(query);
        	}catch(Exception e)
        	{
        		System.out.println(e);
        		e.printStackTrace();
        	}
    }
  //TOADD
  public void AddStatRecord(CryptoStats stat){
	  String table_name = stat.getName().replace(" ","_");
	  createTableByName(table_name);
	  insertStatIntoCrypto(stat, table_name);
	  
  }
  //ADDED
//TOADD
 public List<CryptoStats> GetAllRecordsByTable(String table_name,int n_last_hour) {
	 Timestamp current_time = new Timestamp(System.currentTimeMillis());
	// Date d = initDate();
	 Timestamp timeBefore =  new Timestamp(current_time.getTime()-n_last_hour*3600*1000);
     StringBuilder sb = new StringBuilder("SELECT * FROM ").append(table_name).append(" WHERE time_insert >= '")
    		 .append(timeBefore)
    		 .append("' ALLOW FILTERING");
     //System.out.println(sb);

     final String query = sb.toString();
     ResultSet rs = session.execute(query);

     List<CryptoStats> list_cryptoStats = new ArrayList<CryptoStats>();

     for (Row r : rs) {
     	CryptoStats stat = new CryptoStats( r.getString("name")
     			, r.getDouble("rsi_1h")
     			, r.getDouble("rsi_24h")
     			, r.getDouble("rsi_7d")
     			, r.getDouble("rsi_annualise")
     			, r.getDouble("tauxMarche"));
     	
       
     	list_cryptoStats.add(stat);
     }
     return list_cryptoStats;
 }
 //TOADD
 public List< List<CryptoStats> > GetAllRecords(List<String> tables_name,int n_last_hours){
	 List< List<CryptoStats> > L = new ArrayList<List<CryptoStats>>() ;
	 int n = tables_name.size();
	 for(int i = 0 ; i<n;i++){
		 L.add(GetAllRecordsByTable(tables_name.get(i),n_last_hours));
	 }
	 
	return L;
	 
 }
}