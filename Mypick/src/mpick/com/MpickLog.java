package mpick.com;

import java.io.ObjectInputStream.GetField;
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
		
		str.append(",");
		str.append("\"os\":");
		str.append("\""+getOS(req)+"\"");
		
		str.append(",");
		str.append("\"browser\":");
		str.append("\""+getBrowser(req)+"\"");
		
		String page = req.getRequestURI();
		str.append(",");
		str.append("\"page\":");
		str.append("\""+page+"\"");
		str.append("}");
		
		log.debug(str.toString());
	}
	
	private static String getOS(HttpServletRequest req){
		String header = req.getHeader("User-Agent");
		String os = "os_error";
		try{
			if(header.indexOf("Windows") > -1){
				os = header.substring(header.indexOf("Windows")-7,header.indexOf("Windows")+7);
			} else {
				if(header.indexOf("Android") != -1){
					os = "Android";
				} else if(header.indexOf("Mac OS") != -1){
					os = "Mac OS";
				} else if(header.indexOf(";") != -1){
					os = os.substring(0,os.indexOf(";"));
				}
			}
		} catch(Exception e){ 
			// e.getStackTrace();
		}
		return os.trim();
	}
	
	private static String getBrowser(HttpServletRequest req){
		String header = req.getHeader("User-Agent");
		String browser = "bw_error";
		try{
			if(header.indexOf("Trident") != -1){
				browser = "MSIE";
			} else {
				browser = header.substring(header.lastIndexOf(")")+1);
				if(browser.indexOf("Chrome") != -1){
					browser = browser.substring(browser.indexOf("Chrome"));
					browser = browser.substring(0,browser.indexOf(" "));
				} else {
					browser = browser.substring(browser.lastIndexOf(" "));
				}
			}
			if(browser.indexOf("/") > 0){
				browser = browser.substring(0, browser.indexOf("/"));
			}
		} catch(Exception e){
			// 파싱 오류 발생시 DEVICE 에 모든 헤더를 넣고 BRW 는 빈 값으로 설정. 
			// e.getStackTrace();
		}
		return browser.trim();
	}
		
}
