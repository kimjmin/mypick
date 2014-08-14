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

public class Encyclopedia extends HttpServlet {
	
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
			String subUri = uri.substring(uri.lastIndexOf("Encl/")+5);
			
			if(subUri == null || "".equals(subUri.trim())){
				MpickDao daoM = MpickDao.getInstance();
				DataEntity[] menuDatas = daoM.getMenu();
				if(menuDatas.length > 0){
					res.sendRedirect(MpickParam.hostUrl+"/Encl/"+(String)menuDatas[0].get("ar_menu_id"));
				} else {
					out.print(MpickMsg.approachError());
				}
			} else {
				String[] subUris = subUri.split("/");
				String menu = "";
				String cate1 = "";
				String cate2 = "";
				String arcNum = "";
				if(subUris.length > 4 || subUris.length < 1){
					out.print(MpickMsg.approachError());
				} else {
					if(subUris.length > 3){ arcNum = subUris[3]; }
					if(subUris.length > 2){ cate2 = subUris[2]; }
					if(subUris.length > 1){ cate1 = subUris[1]; }
					if(subUris.length > 0){ menu = subUris[0]; }
					req.getRequestDispatcher("/encl/encyclopedia.jsp?menu="+menu+"&cate1="+cate1+"&cate2="+cate2+"&arcNum="+arcNum).include(req, res);
				}
			}
			
		}
		
	}
	
}
