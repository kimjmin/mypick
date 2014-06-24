package mpick.auth;

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
			if(obj != null && obj.getId() != null && !"".equals(obj.getId())){
				result = dao.insertUserObj(obj);
			}
			
			if (result > 0) {
				session.setAttribute("candiId", obj.getId());
				session.setAttribute("candiUserObj", obj);
								
				try {Thread.sleep(2000);} catch (InterruptedException e) { }
				
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"저장하는데 문제가 발생했습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("update")){
			// 여긴 좀 더 자세히 정비할것.
//			obj = (CandiUserObj) session.getAttribute("cdpObj");
			obj = dao.getUserObj(req, obj);
			
			result = dao.updateUserObj(obj);
//			io.saveConfig(obj);
			
			if (result > 0) {
				session.setAttribute("candiId", obj.getId());
				session.setAttribute("candiUserObj", obj);
				
				res.sendRedirect(toUrl);
			} else {
				out.println("<script>");
				out.println("	alert(\"저장하는데 문제가 발생했습니다.\");");
				out.println("	history.go(-1);");
				out.println("</script>");
			}
		} else if(toUrl != null && cmd != null && cmd.equals("login")){
			
			String id = req.getParameter("id");
			String passwd = req.getParameter("passwd");
			int check = dao.login(id, passwd);
			
			if (check == 2) {
				obj = dao.getUserObj(id);
				session.setAttribute("candiId", obj.getId());
				session.setAttribute("candiUserObj", obj);
				
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
			
			session.removeAttribute("candiId");
			session.removeAttribute("candiUserObj");
			
			if(toUrl != null && !toUrl.equals("")){
				res.sendRedirect(toUrl);
			} else {
				res.sendRedirect("index.jsp");
			}
			
		} else {
			out.println("<script>");
			out.println("	alert(\"잘못된 접근입니다.\");");
			out.println("	history.go(-1);");
			out.println("</script>");
		}
		
	}
}
