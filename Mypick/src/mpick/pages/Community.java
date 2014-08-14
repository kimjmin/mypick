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
			String subUri = uri.substring(uri.lastIndexOf("Comm/")+5);
			
			if(subUri == null || "".equals(subUri.trim())){
				MpickDao daoM = MpickDao.getInstance();
				DataEntity[] menuDatas = daoM.getCommMenu();
				if(menuDatas.length > 0){
					res.sendRedirect(MpickParam.hostUrl+"/Comm/"+(String)menuDatas[0].get("bbs_menu_id"));
				} else {
					out.print(MpickMsg.approachError());
				}
			} else {
				String[] subUris = subUri.split("/");
				String bbs = "";
				String ctrl = "";
				String t_num = "";
				if(subUris.length > 3 || subUris.length < 1){
					out.print(MpickMsg.approachError());
				} else {
					if(subUris.length > 2){ t_num = subUris[2]; }
					if(subUris.length > 1){ ctrl = subUris[1]; }
					if(subUris.length > 0){ bbs = subUris[0]; }
					req.getRequestDispatcher("/comm/community.jsp?bbs="+bbs+"&ctrl="+ctrl+"&t_num="+t_num).include(req, res);
				}
				
			}
		}
		
	}
	
}
