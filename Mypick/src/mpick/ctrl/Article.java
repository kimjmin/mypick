package mpick.ctrl;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jm.net.DataEntity;
import mpick.com.MpickDao;
import mpick.com.MpickUserObj;

public class Article {
	
	public int saveArticle(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, FileNotFoundException, IOException{
		int result = 0;
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		String userMail = userObj.getEmail();
		String arcMenu = req.getParameter("arcMenu");
		String arcCate1 = req.getParameter("arcCate1");
		String arcCate2 = req.getParameter("arcCate2");
		String arcTitleSel = req.getParameter("arcTitleSel");
		String arcTitle = req.getParameter("arcTitle");
		String encText = req.getParameter("encText");
		MpickDao dao = MpickDao.getInstance();
		
		if(arcCate2 != null && !"".equals(arcCate2)){
			String[] arcCates = arcCate2.split("[|]");
			if(arcCates.length == 3){
				if(!"new".equals(arcTitleSel)){
					dao.archiveArticle(arcCates[0], arcCates[1], arcCates[2], arcTitleSel);
				}
				result = dao.insertArticle(userMail, arcCates[0], arcCates[1], arcCates[2], arcTitle, encText);
			}
		} else if(arcCate1 != null && !"".equals(arcCate1)){
			String[] arcCates = arcCate1.split("[|]");
			if(arcCates.length == 2){
				dao.archiveArticle(arcCates[0], arcCates[1], "", "");
				result = dao.insertArticle(userMail, arcCates[0], arcCates[1], "", "", encText);
			}
		} else if(arcMenu != null && !"".equals(arcMenu)){
			dao.archiveArticle(arcMenu, "", "", "");
			result = dao.insertArticle(userMail, arcMenu, "", "", "", encText);
		}
		return result;
	}
	
	public String getArticle(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, FileNotFoundException, IOException{
		String result = "";
		DataEntity[] data = null;
		String arcMenu = req.getParameter("arcMenu");
		String arcCate1 = req.getParameter("arcCate1");
		String arcCate2 = req.getParameter("arcCate2");
		String arcTitleSel = req.getParameter("arcTitleSel");
		if("new".equals(arcTitleSel)){
			arcTitleSel = "";
		}
//		System.out.println("arcTitleSel: "+arcTitleSel);
//		System.out.println("arcMenu: "+arcMenu);
//		System.out.println("arcCate1: "+arcCate1);
//		System.out.println("arcCate2: "+arcCate2);
		
		MpickDao dao = MpickDao.getInstance();
		if(arcCate2 != null && !"".equals(arcCate2) && !"null".equals(arcCate2)){
			String[] arcCates = arcCate2.split("[|]");
			if(arcCates.length == 3){
				data =  dao.getArticle(arcCates[0], arcCates[1], arcCates[2], arcTitleSel);
				if(data != null && data.length > 0){
					result = (String)data[0].get("ar_text");
				}
			}
		} else if(arcCate1 != null && !"".equals(arcCate1) && !"null".equals(arcCate1)){
			String[] arcCates = arcCate1.split("[|]");
			if(arcCates.length == 2){
				data =  dao.getArticle(arcCates[0], arcCates[1], "", arcTitleSel);
				if(data != null && data.length > 0){
					result = (String)data[0].get("ar_text");
				}
			}
		} else if(arcMenu != null && !"".equals(arcMenu) && !"null".equals(arcMenu)){
			data =  dao.getArticle(arcMenu, "", "", arcTitleSel);
			if(data != null && data.length > 0){
				result = (String)data[0].get("ar_text");
			}
		}
		//이미지 리사이징 적용.
		result = result.replaceAll("<img ", "<img class=\"img-responsive\" ");
		return result;
	}
	
	public int delArticle(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, FileNotFoundException, IOException{
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
	
	public int saveCate(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, FileNotFoundException, IOException{
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
	
	public int delNSaveCate(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, FileNotFoundException, IOException{
		MpickDao dao = MpickDao.getInstance();
		dao.deleteAllCates();
		this.modifArcCate(req, res);
		return saveCate(req, res);
	}
	
	private void modifArcCate(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, FileNotFoundException, IOException{
		String[] menuChg = req.getParameterValues("menuChg");
		String[] cage1Chg = req.getParameterValues("cage1Chg");
		String[] cage2Chg = req.getParameterValues("cage2Chg");
		MpickDao dao = MpickDao.getInstance();
		
		if(menuChg != null && menuChg.length > 0){
			for(int i=0; i<menuChg.length; i++){
				String[] menus = menuChg[i].split(",");
				if(menus.length == 2){
					dao.updateArcMenu(menus[0], menus[1]);
				}
			}
		}
		
		if(cage1Chg != null && cage1Chg.length > 0){
			for(int i=0; i<cage1Chg.length; i++){
				String[] cate1s = cage1Chg[i].split(",");
				if(cate1s.length == 2){
					String[] cate1s0 = cate1s[0].split("[|]");
					String[] cate1s1 = cate1s[1].split("[|]");
					if(cate1s0.length == 2 && cate1s1.length == 2){
						dao.updateArcCate1(cate1s0[0], cate1s0[1], cate1s1[0], cate1s1[1]);
					}
				}
			}
		}
		
		if(cage2Chg != null && cage2Chg.length > 0){
			for(int i=0; i<cage2Chg.length; i++){
				String[] cate2s = cage2Chg[i].split(",");
				if(cate2s.length == 2){
					String[] cate2s0 = cate2s[0].split("[|]");
					String[] cate2s1 = cate2s[1].split("[|]");
					if(cate2s0.length == 3 && cate2s1.length == 3){
						dao.updateArcCate2(cate2s0[0], cate2s0[1], cate2s0[2], cate2s1[0], cate2s1[1], cate2s1[2]);
					}
				}
			}
		}
	}
	
}
