package mpick.pages;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mpick.com.MpickMsg;
import mpick.com.MpickParam;
import mpick.com.MpickUserObj;

public class Calculator extends HttpServlet {
	
	private static final long serialVersionUID = -58333958913951824L;
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		PrintWriter out = res.getWriter();
		//로그인 체크. MpickParam.login == true 일 때만 체크.
		if( "true".equals(MpickParam.login) && (userObj == null || "".equals(userObj.getEmail())) ){
			out.print(MpickMsg.loginError());
		} else {
			String uri = req.getRequestURI();
			String subUri = uri.substring(uri.lastIndexOf("Calc/")+5);
			if(subUri.indexOf("/") > 0){
				out.print(MpickMsg.approachError());
			} else {
				String m = "fee";
				if(uri.indexOf("Tax") > 0){
					m = "tax";
				} else if(uri.indexOf("Trans") > 0){
					m = "trans";
				} else if(uri.indexOf("Volume") > 0){
					m = "volume";
				}
				req.getRequestDispatcher("/calc/calculator.jsp?m="+m).include(req, res);
			}
		}
		
	}
	
}
