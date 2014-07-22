package mpick.ctrl;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mpick.com.MpickDao;
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
			if(!preobj.getPasswd().equals(prePasswd)){
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
				res.sendRedirect("../Calc/Fee");
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
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"정보를 저장하는 중 오류가 발생되었습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else {
			out.println("<script>");
			out.println("	alert(\"잘못된 접근입니다.\");");
			out.println("	history.go(-1);");
			out.println("</script>");
		}
		
	}
}
