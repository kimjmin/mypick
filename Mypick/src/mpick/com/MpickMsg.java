package mpick.com;

public class MpickMsg {
	
	/**
	 * 로그인 오류 메시지. login.jsp 페이지로 이동.
	 * @return
	 */
	public static String loginError(){
		StringBuffer msg = new StringBuffer();
		
		msg.append("<script> \n");
		msg.append("	alert(\"로그인 후 이용해 주시기 바랍니다.\"); \n");
		msg.append("	location.replace('http://mypick.kr'); \n");
		msg.append("</script> \n");
		
		return msg.toString();
	}
	
	public static String approachError(){
		StringBuffer msg = new StringBuffer();
		msg.append("<script> \n");
		msg.append("	alert(\"잘못된 접근입니다.\"); \n");
		msg.append("	history.go(-1); \n");
		msg.append("</script> \n");
		
		return msg.toString();
	}
	
}
