package mpick.pages;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mpick.com.MpickMsg;
import mpick.com.MpickUserObj;

public class Admin extends HttpServlet {
	
	private static final long serialVersionUID = -58333958913951824L;
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		PrintWriter out = res.getWriter();
		//무조건 로그인 해야 보임. ADMIN 일 때만.
		if(userObj == null || !"ADMIN".equals(userObj.getState())){
			out.print(MpickMsg.approachError());
		} else {
			String uri = req.getRequestURI();
			String subUri = uri.substring(uri.lastIndexOf("Admin/")+6);
			if(subUri.indexOf("/") > 0){
				out.print(MpickMsg.approachError());
			} else {
				String m = "ship";
				if(uri.indexOf("Encl") > 0){
					m = "encl";
				} else if(uri.indexOf("Comm") > 0){
					m = "comm";
				}
				req.getRequestDispatcher("/admin/admin.jsp?m="+m).include(req, res);
			}
		}
		
	}
	
}
