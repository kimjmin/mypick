package mpick.pages.encl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Atoz extends HttpServlet {
	
	private static final long serialVersionUID = 1854427970106978386L;

	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		req.getRequestDispatcher("/encl/encyclopedia.jsp").include(req, res);
	}
	
}
