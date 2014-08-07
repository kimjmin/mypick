package mpick.com;

import jm.com.JmProperties;

public class MpickParam {
	public static final String property = "/data/MYPICK/config/mpick.property";
	private static JmProperties prop = new JmProperties(MpickParam.property);
	
	public static final String hostUrl = prop.get("hostUrl");
	public static final String initPage = prop.get("initPage");
	public static final String login = prop.get("login");
}
