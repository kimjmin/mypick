package mpick.pages;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Admin extends HttpServlet {
	
	private static final long serialVersionUID = -58333958913951824L;
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		
		String uri = req.getRequestURI();
		String m = "ship";
		if(uri.indexOf("Encl") > 0){
			m = "encl";
		} else if(uri.indexOf("Comm") > 0){
			m = "comm";
		}
		
		req.getRequestDispatcher("/admin/admin.jsp?m="+m).include(req, res);
	}
	
}
