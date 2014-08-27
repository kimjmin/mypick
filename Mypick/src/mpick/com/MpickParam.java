package mpick.com;

import jm.com.JmProperties;

public class MpickParam {
	public static String property = "/data/MYPICK/config/mpick.property";
	private static JmProperties prop;
	
	public static String getHostUrl(){
		try {
			prop = new JmProperties(MpickParam.property);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return prop.get("hostUrl");
	}
	public static String getInitPage(){
		try {
			prop = new JmProperties(MpickParam.property);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return prop.get("initPage");
	}
	public static String getLogin(){
		try {
			prop = new JmProperties(MpickParam.property);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return prop.get("login");
	}
	
}
