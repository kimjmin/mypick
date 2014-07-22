package mpick.pages;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Encyclopedia extends HttpServlet {
	
	private static final long serialVersionUID = 1854427970106978386L;

	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		
		String uri = req.getRequestURI();
		/*
		String m = "atoz";
		if(uri.indexOf("Tax") > 0){
			m = "tax";
		} else if(uri.indexOf("Refund") > 0){
			m = "refund";
		} else if(uri.indexOf("Exchange") > 0){
			m = "exchange";
		}
		*/
		req.getRequestDispatcher("/encl/encyclopedia.jsp?uri="+uri).include(req, res);
	}
	
}
