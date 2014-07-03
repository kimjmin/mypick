package mpick.ctrl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Modify extends HttpServlet{
	
	private static final long serialVersionUID = 2511820546476863064L;

	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		req.getRequestDispatcher("/ctrl/user_modify.jsp").include(req, res);
	}
}
