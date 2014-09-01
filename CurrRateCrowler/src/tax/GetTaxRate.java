package tax;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;

import jm.com.JmProperties;
import jm.net.Dao;
import jm.net.DataEntity;

public class GetTaxRate {
	public void getInfo() throws UnsupportedEncodingException, FileNotFoundException, IOException{
		BufferedReader reader = null;
		URL url = null;
		boolean sp = false;
		boolean tableSt = false;
		int tdCnt = 0;
		String curr = "";
		String curr_kr = "";
		String tax_rate = "";
		String unit = "";
		Dao dao = Dao.getInstance();
		JmProperties property = new JmProperties("/data/MYPICK/config/mpick.property");
		DataEntity data = null;
		dao.deleteAll(property, "mp_curr_tax_rate");
		int onum = 1;
		try {
			url = new URL("http://portal.customs.go.kr/ImpPt/InfoOfferAction_42.do?method=selectEximXchgList&key_exim_ditc=2");
		    reader = new BufferedReader(new InputStreamReader(url.openStream(), "EUC-KR"));

		    for (String line; (line = reader.readLine()) != null;) {
		    	if(line.indexOf("주간환율") > 0) { sp = true; }
		    	if(line.indexOf("용역업자") > 0) { sp = false; }
		    	if(sp){
		    		if(line.indexOf("<tbody>") > 0) { tableSt = true; }
		    		if(line.indexOf("</tbody>") > 0) { tableSt = false; }
		    		if(tableSt){
		    			if(line.indexOf("<tr") > 0) {
		    				tdCnt = 0;
		    				data = new DataEntity();
		    			}
			    		
		    			if(tdCnt == 2){
		    				curr_kr = line.substring(line.indexOf(">")+1, line.lastIndexOf("<"));
		    			}
		    			if(tdCnt == 3){
		    				curr = line.substring(line.indexOf(">")+1, line.lastIndexOf("<"));
		    			}
		    			if(tdCnt == 7){
		    				tax_rate = line.substring(line.indexOf(">")+1, line.indexOf("&nbsp"));
		    			}
		    			if(tdCnt == 8){
		    				unit = line.substring(line.indexOf(">")+1, line.lastIndexOf("<"));
		    			}
		    			if(tdCnt == 9){
			    			data.put("onum",onum);
			    			data.put("curr_kr",curr_kr);
			    			data.put("curr",curr);
			    			data.put("tax_rate",tax_rate.replaceAll(",",""));
			    			data.put("unit",unit);
			    			dao.inertData(property, "mp_curr_tax_rate", data);
			    			onum++;
		    			}
		    			tdCnt++;
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
