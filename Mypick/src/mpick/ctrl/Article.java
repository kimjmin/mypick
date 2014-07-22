package mpick.ctrl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jm.net.DataEntity;
import mpick.com.MpickDao;
import mpick.com.MpickUserObj;

public class Article {
	
	public int saveArticle(HttpServletRequest req, HttpServletResponse res){
		int result = 0;
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		String userMail = userObj.getEmail();
		String encType = req.getParameter("encType");
		String encText = "";
		if("ATOZ".equals(encType)){
			encText = req.getParameter("encText1");
		} else if("TAX".equals(encType)){
			encText = req.getParameter("encText2");
		} else if("REFUND".equals(encType)){
			encText = req.getParameter("encText3");
		} else if("EXCHANGE".equals(encType)){
			encText = req.getParameter("encText4");
		}
		
		MpickDao dao = MpickDao.getInstance();
		dao.archiveArticle(encType);
		result = dao.insertArticle(userMail, encType, encText);
		
		return result;
	}
	
	public String getArticle(String encType){
		String result = "";
		
		DataEntity[] data = null;
		MpickDao dao = MpickDao.getInstance();
		data =  dao.getArticle(encType);
		if(data != null && data.length > 0){
			result = (String)data[0].get("ar_text");
		}
		return result;
	}
			
}
