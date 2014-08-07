package mpick.pages;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mpick.com.MpickParam;

public class Init extends HttpServlet{
	
	private static final long serialVersionUID = -5327394839872583494L;
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		req.getRequestDispatcher(MpickParam.initPage).include(req, res);
	}
}
