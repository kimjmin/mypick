package mpick.ctrl;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jm.com.Encrypt;
import mpick.com.MpickDao;
import mpick.com.MpickIO;
import mpick.com.MpickParam;
import mpick.com.MpickUserObj;

public class Confirm extends HttpServlet {
	
	private static final long serialVersionUID = 4784289161430396081L;
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException {
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		String cmd = req.getParameter("cmd");
		String toUrl = req.getParameter("toUrl");
		HttpSession session = req.getSession();
		
		MpickDao dao = MpickDao.getInstance(); 
		MpickUserObj obj = null;
		int result = 0;
		
		if(toUrl != null && cmd != null && cmd.equals("insert")){
			
			obj = dao.getUserObj(req);
			if(obj != null && obj.getEmail() != null && !"".equals(obj.getEmail())){
				result = dao.insertUserObj(obj);
			}
			if (result > 0) {
				session.setAttribute("mpUserObj", obj);
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"저장하는데 문제가 발생했습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("modify")){
			MpickUserObj preobj = dao.getUserObj(req.getParameter("email"));
			String prePasswd = req.getParameter("prepasswd");
			if(!preobj.getPasswd().equals(Encrypt.getSha256(prePasswd))){
				out.println("<script>");
				out.println("	alert(\"기존 패스워드가 올바르지 않습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			} else {
				obj = dao.getUserObj(req);
				if(obj != null && obj.getEmail() != null && !"".equals(obj.getEmail())){
					result = dao.updateUserObj(obj);
				}
				if (result > 0) {
					session.setAttribute("mpUserObj", obj);
					res.sendRedirect(toUrl);
				} else {
					out.println("<script>");
					out.println("	alert(\"저장하는데 문제가 발생했습니다.\");");
					out.println("	history.go(-1);");
					out.println("</script>");
				}
			}
		} else if(toUrl != null && cmd != null && cmd.equals("login")){
			
			String email = req.getParameter("loginEmail");
			String passwd = req.getParameter("loginPw");
			int check = dao.login(email, passwd);
			
			if (check == 2) {
				obj = dao.getUserObj(email);
				session.setAttribute("mpUserObj", obj);
				res.sendRedirect(toUrl);
			} else if (check == 1) {
				out.println("<script>");
				out.println("	alert(\"비밀번호가 맞지 않습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			} else if (check == 0) {
				out.println("<script>");
				out.println("	alert(\"없는 ID입니다. 다시 확인하고 로그인 하십시오.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("	alert(\"로그인 하는 도중 오류가 발생했습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(cmd != null && cmd.equals("logout")){
			session.removeAttribute("mpUserObj");
			if(toUrl != null && !toUrl.equals("")){
				res.sendRedirect(toUrl);
			} else {
				res.sendRedirect(MpickParam.hostUrl);
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveShip")){
			//배송대행지 저장.
			ShipComps sc = new ShipComps();
			int shipRes = sc.saveShipCompList(req, res);
			if(shipRes > 0){
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"배송대행업체 정보를 저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveEncl")){
			//백과사전 AtoZ 저장.
			Article arc = new Article();
			int arcRes = arc.saveArticle(req, res);
			if(arcRes > 0){
//				res.sendRedirect(toUrl);
				out.println("<form name='cateFrm' action='"+toUrl+"' method='POST'>\n");
				out.println("<input type='hidden' name='enclTab' value='arc'/>\n");
				out.println("</form>\n");
				
				out.println("<script>\n");
				out.println("var frm = document.cateFrm;\n");
				out.println("frm.submit();\n");
				out.println("</script>\n");
				
			} else {
				out.println("<script>");
				out.println("	alert(\"정보를 저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("delEncl")){
			//백과사전 AtoZ 저장.
			Article arc = new Article();
			int arcRes = arc.delArticle(req, res);
			if(arcRes > 0){
//				res.sendRedirect(toUrl);
				out.println("<form name='cateFrm' action='"+toUrl+"' method='POST'>\n");
				out.println("<input type='hidden' name='enclTab' value='arc'/>\n");
				out.println("</form>\n");
				
				out.println("<script>\n");
				out.println("var frm = document.cateFrm;\n");
				out.println("frm.submit();\n");
				out.println("</script>\n");
				
			} else {
				out.println("<script>");
				out.println("	alert(\"삭제하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveCate")){
			//카테고리 저장.
			Article arc = new Article();
//			int cateRes = arc.delNSaveCate(req, res);
			int cateRes = arc.saveCate(req, res);
			if(cateRes > 0){
				arc.delNSaveCate(req, res);
			}
			if(cateRes > 0){
//				res.sendRedirect(toUrl);
				out.println("<form name='cateFrm' action='"+toUrl+"' method='POST'>\n");
				out.println("<input type='hidden' name='enclTab' value='cate'/>\n");
				out.println("</form>\n");
				
				out.println("<script>\n");
				out.println("var frm = document.cateFrm;\n");
				out.println("frm.submit();\n");
				out.println("</script>\n");
			} else {
				out.println("<script>");
				out.println("	alert(\"정보를 저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveCommCate")){
			//카테고리 저장.
			Comm comm = new Comm();
			int cateRes = comm.saveCate(req, res);
			if(cateRes > 0){
				cateRes = comm.delNSaveCate(req, res);
			}
			if(cateRes > 0){
//				res.sendRedirect(toUrl);
				out.println("<form name='cateFrm' action='"+toUrl+"' method='POST'>\n");
				out.println("<input type='hidden' name='commTab' value='cate'/>\n");
				out.println("</form>\n");
				
				out.println("<script>\n");
				out.println("var frm = document.cateFrm;\n");
				out.println("frm.submit();\n");
				out.println("</script>\n");
			} else {
				out.println("<script>");
				out.println("	alert(\"정보를 저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveCommTxt")){
			Comm comm = new Comm();
			int commRes = comm.saveText(req, res);
			if(commRes > 0){
				String commWriter = (String)session.getAttribute("commWriter");
				MpickIO mio = MpickIO.getInstance();
				mio.moveFile("commPath",commWriter+"/temp",commWriter+"/"+commRes);
				res.sendRedirect(toUrl+"/View/"+commRes);
			} else {
				out.println("<script>");
				out.println("	alert(\"정보를 저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveCommReply")){
			Comm comm = new Comm();
			int commRes = comm.saveReply(req, res);
			if(commRes > 0){
				String tNum = req.getParameter("tNum");
				res.sendRedirect(toUrl+"/View/"+tNum);
			} else {
				out.println("<script>");
				out.println("	alert(\"정보를 저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("deleteCommReply")){
			Comm comm = new Comm();
			int commRes = comm.delReply(req, res);
			if(commRes > 0){
				String tNum = req.getParameter("tNum");
				res.sendRedirect(toUrl+"/View/"+tNum);
			} else {
				out.println("<script>");
				out.println("	alert(\"삭제하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("deleteCommTxt")){
			Comm comm = new Comm();
			int commRes = comm.delTxt(req, res);
			if(commRes > 0){
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"삭제하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("blockCommTxt")){
			Comm comm = new Comm();
			int commRes = comm.blockTxt(req, res);
			if(commRes > 0){
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"상태를 변경하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("unblockCommTxt")){
			Comm comm = new Comm();
			int commRes = comm.unblockTxt(req, res);
			if(commRes > 0){
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"상태를 변경하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveMenuMsg")){
			int resCnt = 1;
			String[] hid = req.getParameterValues("hid");
			String[] mid = req.getParameterValues("mid");
			String[] mTitle = req.getParameterValues("mTitle");
			String[] mText = req.getParameterValues("mText");
			if(hid != null && hid.length > 0){
				dao.delMenuMsg();
				for(int i=0; i < hid.length; i++){
					String mHide = req.getParameter("mHide"+i);
					if(!"".equals(hid[i]) && !"".equals(mid[i])){
						if(dao.insertMenuMsg(i, hid[i], mid[i], mTitle[i], mText[i], mHide) == 0){
							resCnt = 0;
						}
					}
				}
			}
			if(resCnt > 0){
				out.println("<form name='cateFrm' action='"+toUrl+"' method='POST'>\n");
				out.println("<input type='hidden' name='msgTab' value='msg'/>\n");
				out.println("</form>\n");
				
				out.println("<script>\n");
				out.println("var frm = document.cateFrm;\n");
				out.println("frm.submit();\n");
				out.println("</script>\n");
			} else {
				out.println("<script>");
				out.println("	alert(\"저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("saveMenuLink")){
			int resCnt = 1;
			String[] mType = req.getParameterValues("mType");
			String[] mTitle = req.getParameterValues("mTitle");
			String[] mLink = req.getParameterValues("mLink");
			
			if(mTitle != null && mTitle.length > 0){
				dao.delLinks();
				for(int i=0; i < mTitle.length; i++){
					if(!"".equals(mType[i]) && !"".equals(mTitle[i]) && !"".equals(mLink[i])){
						if(dao.insertLinks(i, mType[i], mTitle[i], mLink[i]) == 0){
							resCnt = 0;
						}
					}
				}
			}
			if(resCnt > 0){
				out.println("<form name='cateFrm' action='"+toUrl+"' method='POST'>\n");
				out.println("<input type='hidden' name='msgTab' value='link'/>\n");
				out.println("</form>\n");
				
				out.println("<script>\n");
				out.println("var frm = document.cateFrm;\n");
				out.println("frm.submit();\n");
				out.println("</script>\n");
			} else {
				out.println("<script>");
				out.println("	alert(\"저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else {
//			System.out.println("cmd : "+cmd);
//			System.out.println("toUrl : "+toUrl);
			out.println("<script>");
			out.println("	alert(\"잘못된 접근입니다.\");");
			out.println("	history.go(-1);");
			out.println("</script>");
		}
		
	}
}
