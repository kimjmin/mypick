package mpick.pages;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jm.net.DataEntity;
import mpick.com.MpickDao;
import mpick.com.MpickMsg;
import mpick.com.MpickParam;
import mpick.com.MpickUserObj;

public class Community extends HttpServlet {
	
	private static final long serialVersionUID = 1854427970106978386L;

	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		res.setContentType("text/html; charset=UTF-8");
		
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		PrintWriter out = res.getWriter();
		//로그인 체크. MpickParam.login == true 일 때만 체크.
		if( "true".equals(MpickParam.login) && (userObj == null || "".equals(userObj.getEmail())) ){
			out.print(MpickMsg.loginError());
		} else {
			String uri = req.getRequestURI();
			String subUri = uri.substring(uri.lastIndexOf("Comm/")+4);
			if(subUri.indexOf("/") > 2){
				out.print(MpickMsg.approachError());
			} else {
				String bbs = "";
				if(subUri == null || "".equals(subUri.trim()) || "/".equals(subUri.trim()) ){
					MpickDao daoM = MpickDao.getInstance();
					DataEntity[] menuDatas = daoM.getCommMenu();
					if(menuDatas.length > 0){
						bbs = (String)menuDatas[0].get("bbs_menu_id");
					}
				} else {
					bbs = uri.substring(uri.lastIndexOf("Comm/")+5);
				}
				String m = "list";
				if(subUri.indexOf("Write") > 0){
					m = "write";
				} else if (subUri.indexOf("Modify") > 0){
					m = "modify";
				}
				String t_num = req.getParameter("t_num");
				if(t_num == null) t_num = "";
				req.getRequestDispatcher("/comm/community.jsp?bbs="+bbs+"&m="+m+"&t_num="+t_num).include(req, res);
			}
		}
		
	}
	
}
