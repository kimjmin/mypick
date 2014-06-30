package mpick.ctrl;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mpick.com.MpickDao;

public class MpickAjax extends HttpServlet{
	
	private static final long serialVersionUID = 8075039219880337611L;

	/**
	 * Candi 에서 사용하는 Ajax.
	 */
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		MpickDao dao = MpickDao.getInstance();
		String cmd = req.getParameter("cmd");
		if(cmd != null){
			/**
			 * 중복 ID 체크.
			 */
			if(cmd.equals("checkMail")){
				String email = req.getParameter("email");
				if(!dao.isExistMail(email)){
					out.print("{\"result\":\"OK\"}");
				} else {
					out.print("{\"result\":\"EXIST\"}");
				}
			} else if(cmd.equals("checkNick")){
				String nicname = req.getParameter("nicname");
				if(!dao.isExistNicname(nicname)){
					out.print("{\"result\":\"OK\"}");
				} else {
					out.print("{\"result\":\"EXIST\"}");
				}
			}
			
		}
		
	}
	
}
