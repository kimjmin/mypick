package mpick.auth;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mpick.com.MpickDao;

public class MpickAjax extends HttpServlet{
	
	private static final long serialVersionUID = -4496829789988209505L;

	/**
	 * Candi 에서 사용하는 Ajax.
	 */
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		MpickDao dao = MpickDao.getInstance();
		String cmd = req.getParameter("cmd");
		System.out.println("cmd : "+cmd);
		if(cmd != null){
			/**
			 * 중복 ID 체크.
			 */
			if(cmd.equals("checkId")){
				String id = req.getParameter("id");
				if(!dao.isExistId(id)){
					System.out.println("OK");
					out.print("{\"result\":\"OK\"}");
				} else {
					System.out.println("EXIST");
					out.print("{\"result\":\"EXIST\"}");
				}
			}
		}
		
	}
	
}
