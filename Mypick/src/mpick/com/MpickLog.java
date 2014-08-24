package mpick.com;

import java.io.ObjectInputStream.GetField;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.crypto.URIDereferencer;

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
		
		String page;
		try {
			page = URLDecoder.decode(req.getRequestURI(),"UTF-8");
		} catch (UnsupportedEncodingException e) {
			page = req.getRequestURI();
		}
		str.append(",");
		str.append("\"page\":");
		str.append("\""+page+"\"");
		str.append("}");
		
		log.debug(str.toString());
	}
	
	private static String getOS(HttpServletRequest req){
		String header = req.getHeader("User-Agent");
		String os = "UnknownOs";
		try{
			if(header.indexOf("Windows") > -1){
				os = "Windows";
			} else if(header.indexOf("Android") > -1){
				os = "Android";
			} else if(header.indexOf("Macintosh") > -1){
				os = "Macintosh";
			} else if(header.indexOf("iPhone") > -1){
				os = "iPhone";
			} else if(header.indexOf("Linux") > -1){
				os = "Linux";
			}
		} catch(Exception e){ 
			// e.getStackTrace();
		}
		return os.trim();
	}
	
	private static String getBrowser(HttpServletRequest req){
		String header = req.getHeader("User-Agent");
		String browser = "UnknownBrowser";
		try{
			if(header.indexOf("Trident") > -1){
				browser = "MSIE";
			} else if(header.indexOf("Chrome") > -1){
				browser = "Chrome";
			} else if(header.indexOf("Firefox") > -1){
				browser = "Firefox";
			} else if(header.indexOf("Safari") > -1){
				browser = "Safari";
			} else if(header.indexOf("Opera") > -1){
				browser = "Opera";
			}
		} catch(Exception e){
			// 파싱 오류 발생시 DEVICE 에 모든 헤더를 넣고 BRW 는 빈 값으로 설정. 
			// e.getStackTrace();
		}
		return browser.trim();
	}
		
}
