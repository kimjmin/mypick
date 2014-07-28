package mpick.com;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jm.log.Log;

public class MpickLog {
	
	public static void debug(HttpServletRequest req){
		Log log = Log.getInstance(MpickParam.property);
		
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		String user = "guest";
		if(userObj != null && !"".equals(userObj.getEmail())){
			user = userObj.getEmail();
		}
		StringBuffer str = new StringBuffer();
		str.append("{");
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
		SimpleDateFormat formatter2 = new SimpleDateFormat("HH:mm:ss", Locale.KOREA);
		str.append("\"logTime\":");
		str.append("\""+formatter1.format(new Date())+"T"+formatter2.format(new Date())+"\"");
		str.append(",");
		str.append("\"user\":");
		str.append("\""+user+"\"");
		String ipAddr = req.getRemoteAddr();
		str.append(",");
		str.append("\"ip\":");
		str.append("\""+ipAddr+"\"");
		String page = req.getRequestURI();
		str.append(",");
		str.append("\"page\":");
		str.append("\""+page+"\"");
		str.append("}");
		
//		System.out.println(str.toString());
		log.debug(str.toString());
	}
}
