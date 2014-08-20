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
		
		boolean loggedIn = false;
		boolean isAdmin = false;
		if(userObj != null && !"".equals(userObj.getEmail())){
			loggedIn = true;
			if("ADMIN".equals(userObj.getState())){
				isAdmin = true;
			}
		}
		
		//로그인 체크. MpickParam.login == true 일 때만 체크.
		if( "true".equals(MpickParam.login) && !loggedIn ){
			out.print(MpickMsg.loginError());
		} else {
			String uri = req.getRequestURI();
			String subUri = uri.substring(uri.lastIndexOf("Comm/")+5);
			MpickDao dao = MpickDao.getInstance();
			if(subUri == null || "".equals(subUri.trim())){
				DataEntity[] menuDatas = dao.getCommViewMenu();
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
					int commExist = dao.getCommMenuBbs(bbs);
					int admMenuCnt = dao.getCommMenuAdminBbs(bbs);
					if(commExist == 0){
						out.print(MpickMsg.error("존재하지 않는 게시판입니다."));
					} else {
						if("Write".equals(ctrl)){
							if( !loggedIn ){
								out.print(MpickMsg.error("로그인 후 작성이 가능합니다."));
							} else if(admMenuCnt > 0 && !isAdmin) {
								out.print(MpickMsg.error("해당 게시판은 관리자만 작성이 가능합니다."));
							} else {
								if(t_num !=null && !"".equals(t_num)){
									DataEntity[] tDatas = dao.getCommText(bbs,t_num);
									if(tDatas != null && tDatas.length > 0){
										DataEntity tData = tDatas[0];
										MpickUserObj writerObj = dao.getUserObj(tData.get("user_email")+"");
										if(userObj != null && userObj.getEmail().equals(writerObj.getEmail())){
											req.getRequestDispatcher("/comm/community.jsp?bbs="+bbs+"&ctrl="+ctrl+"&t_num="+t_num).include(req, res);
										} else {
											out.print(MpickMsg.approachError());
										}
									} else {
										out.print(MpickMsg.approachError());
									}
								} else {
									req.getRequestDispatcher("/comm/community.jsp?bbs="+bbs+"&ctrl="+ctrl+"&t_num="+t_num).include(req, res);
								}
							}
						} else if("View".equals(ctrl)){
							DataEntity[] data = dao.getCommText(bbs,t_num);
							if(data == null || data.length == 0){
								out.print(MpickMsg.error("존재하지 않는 글입니다."));
							} else {
								if("LOGIN".equals(data[0].get("t_state")+"") && !loggedIn ){
									out.print(MpickMsg.error("이 글을 조회하려면 로그인이 필요합니다."));
								} else {
									req.getRequestDispatcher("/comm/community.jsp?bbs="+bbs+"&ctrl="+ctrl+"&t_num="+t_num).include(req, res);
								}
							}
						} else {
							req.getRequestDispatcher("/comm/community.jsp?bbs="+bbs+"&ctrl="+ctrl+"&t_num="+t_num).include(req, res);
						}
					}
				}
				
			}
		}
		
	}
	
}
