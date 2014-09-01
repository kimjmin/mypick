package curr;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;

import jm.com.JmProperties;
import jm.net.Dao;
import jm.net.DataEntity;

public class GetCurrRate {

	public void getInfo() throws UnsupportedEncodingException, FileNotFoundException, IOException{
		BufferedReader reader = null;
		URL url = null;
		boolean sp = false;
		String upDate = "";
		String upTime = "";
		Dao dao = Dao.getInstance();
		JmProperties property = new JmProperties("/data/MYPICK/config/mpick.property");
		dao.deleteAll(property, "mp_curr_rate");
		int onum = 1;
		try {
			url = new URL("http://fx.keb.co.kr/FER1101C.web");
		    reader = new BufferedReader(new InputStreamReader(url.openStream(), "EUC-KR"));

		    for (String line; (line = reader.readLine()) != null;) {
		    	if(line.indexOf("srchLayer") > 0) { sp = true; }
		    	if(line.indexOf("linkEmail()") > 0) { sp = false; }
		    	if(sp){
		    		if(line.indexOf("regdt") > 0) { 
		    			upDate = line.substring(line.indexOf(">")+1, line.lastIndexOf("<"));
		    		}
		    		if(line.indexOf("dispTime") > 0) { 
		    			upTime = line.substring(line.indexOf(">")+1, line.lastIndexOf("<"));
		    		}
		    		if(line.indexOf("first_child") > 0 && line.indexOf("tbl_list_type2") < 0) {
		    			int inlinecnt = 0;
		    			DataEntity data = new DataEntity();
		    			data.put("up_date", upDate);
		    			data.put("up_time", upTime.replaceAll("[(]", " ("));
		    			data.put("onum", onum);
		    			while(line.indexOf(">") > 0){
		    				line = line.substring(line.indexOf(">")+1);
		    				if(line.indexOf("<") > 0){
		    					if(inlinecnt == 0){
		    						String currStr = line.substring(0, line.indexOf("<"));
		    						data.put("curr_kr",currStr);
		    						String currS = currStr;
		    						currS = currS.replaceAll("100", "");
		    						currS = currS.trim();
		    						currS = currS.substring(currS.length() - 3);
		    						data.put("curr", currS);
		    					}
		    					
		    					if(inlinecnt == 1){ data.put("cash_buy", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 2){ data.put("cash_buy_rate", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 3){ data.put("cash_sell", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 4){ data.put("cash_sell_rate", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 5){ data.put("trans_send", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 6){ data.put("trans_receive", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 7){ data.put("tc_buy", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 8){ data.put("check_sell", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 9){ data.put("sell_refer", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 10){ data.put("disc_rate", line.substring(0, line.indexOf("<"))); }
		    					if(inlinecnt == 11){ data.put("usd_rate", line.substring(0, line.indexOf("<"))); }
		    					inlinecnt++;
		    				}
		    			}
		    			dao.inertData(property, "mp_curr_rate", data);
		    			onum++;
		    		}
		    	}
		    }
		    
		} catch(Exception e){
			e.printStackTrace();
		}finally {
		    if (reader != null) try { reader.close(); } catch (IOException ignore) {}
		}
		
	}
}
