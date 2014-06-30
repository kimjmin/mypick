package mpick.pages;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Calculator extends HttpServlet {
	
	private static final long serialVersionUID = -58333958913951824L;
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		
		String uri = req.getRequestURI();
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
