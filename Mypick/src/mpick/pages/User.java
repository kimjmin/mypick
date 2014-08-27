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

public class User extends HttpServlet {
	
	private static final long serialVersionUID = -58333958913951824L;
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		PrintWriter out = res.getWriter();
		//로그인 체크. MpickParam.login == true 일 때만 체크.
		if( "true".equals(MpickParam.getLogin()) && (userObj == null || "".equals(userObj.getEmail())) ){
			out.print(MpickMsg.approachError());
		} else {
			String uri = req.getRequestURI();
			String nextUrl = MpickParam.getHostUrl();
			if(uri.indexOf("Modify") > 0){
				nextUrl = "/ctrl/user_modify.jsp";
			} else if(uri.indexOf("Signin") > 0){
				nextUrl = "/ctrl/signin.jsp";
			}
			req.getRequestDispatcher(nextUrl).include(req, res);
		}
		
	}
	
}
