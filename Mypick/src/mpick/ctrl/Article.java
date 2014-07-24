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
		String arcCate = req.getParameter("arcCate2");
		String arcTitleSel = req.getParameter("arcTitleSel");
		String arcTitle = req.getParameter("arcTitle");
		String encText = req.getParameter("encText");
		String[] arcCates = arcCate.split("[|]");
		MpickDao dao = MpickDao.getInstance();
		if(!"new".equals(arcTitleSel) && arcCates.length == 3){
			dao.archiveArticle(arcCates[0], arcCates[1], arcCates[2], arcTitleSel);
		}
		result = dao.insertArticle(userMail, arcCates[0], arcCates[1], arcCates[2], arcTitle, encText);
		return result;
	}
	
	public String getArticle(HttpServletRequest req, HttpServletResponse res){
		String result = "";
		DataEntity[] data = null;
		String arcCate = req.getParameter("arcCate2");
		String arcTitleSel = req.getParameter("arcTitleSel");
		String[] arcCates = arcCate.split("[|]");
		MpickDao dao = MpickDao.getInstance();
		data =  dao.getArticle(arcCates[0], arcCates[1], arcCates[2], arcTitleSel);
		if(data != null && data.length > 0){
			result = (String)data[0].get("ar_text");
		}
		return result;
	}
	
	public int delArticle(HttpServletRequest req, HttpServletResponse res){
		int result = 0;
		String arcCate = req.getParameter("arcCate2");
		String arcTitleSel = req.getParameter("arcTitleSel");
		String[] arcCates = arcCate.split("[|]");
		MpickDao dao = MpickDao.getInstance();
		if(!"new".equals(arcTitleSel) && arcCates.length == 3){
			result = dao.archiveArticle(arcCates[0], arcCates[1], arcCates[2], arcTitleSel);
		}
		return result;
	}
	
	public int saveCate(HttpServletRequest req, HttpServletResponse res){
		int result = 1;
		MpickDao dao = MpickDao.getInstance();
		
		String menu = req.getParameter("menus");
		String cate1 = req.getParameter("cate1s");
		String cate2 = req.getParameter("cate2s");
		
//		System.out.println("menu: "+menu);
//		System.out.println("cate1: "+cate1);
//		System.out.println("cate2: "+cate2);
		
		if(menu != null && !"".equals(menu)){
			String[] menus = menu.split(",");
			for(int i=0; i<menus.length; i++){
				String[] menuVals = menus[i].split("[|]");
				if(menuVals.length == 2){
					if(dao.insertMenus(i, menuVals[0], menuVals[1]) < 1){
						result = 0;
					}
				}
			}
		}
		if(cate1 != null && !"".equals(cate1)){
			String[] cate1s = cate1.split(",");
			for(int i=0; i<cate1s.length; i++){
				String[] cate1Vals = cate1s[i].split("[|]");
				if(cate1Vals.length == 2){
					if(dao.insertCate1(i, cate1Vals[0], cate1Vals[1]) < 1){
						result = 0;
					}
				}
			}
		}
		
		if(cate2 != null && !"".equals(cate2)){
			String[] cate2s = cate2.split(",");
			for(int i=0; i<cate2s.length; i++){
				String[] cate2Vals = cate2s[i].split("[|]");
				if(cate2Vals.length == 3){
					if(dao.insertCate2(i, cate2Vals[0], cate2Vals[1], cate2Vals[2]) < 1){
						result = 0;
					}
				}
			}
		}
		return result;
	}
	
	public int delNSaveCate(HttpServletRequest req, HttpServletResponse res){
		MpickDao dao = MpickDao.getInstance();
		dao.deleteAllCates();
		return saveCate(req, res);
	}
	
}
