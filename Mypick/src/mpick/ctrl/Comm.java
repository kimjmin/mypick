package mpick.ctrl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jm.net.DataEntity;
import mpick.com.MpickDao;
import mpick.com.MpickUserObj;

public class Comm {
	
	public int saveText(HttpServletRequest req, HttpServletResponse res){
		int result = 0;
		int tNum = 0;
		HttpSession session = req.getSession();
		MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
		String userMail = userObj.getEmail();
		String menu = req.getParameter("menu");
		String cate = req.getParameter("cate");
		String tTitle = req.getParameter("tTitle");
		String tLink = req.getParameter("tLink");
		String tState = req.getParameter("tState");
		String tText = req.getParameter("tText");
		
		MpickDao dao = MpickDao.getInstance();
		String tNumStr = req.getParameter("tNum");
		if(tNumStr == null || "".equals(tNumStr)){
			tNum = dao.getMaxCommTxtNum() + 1;
		} else {
			tNum = Integer.parseInt(tNumStr);
			dao.archiveCommText(menu, tNumStr);
		}
		result = dao.insertCommText(tNum, userMail, menu, cate, tTitle, tLink, tState, tText);
		return result;
	}
	
	public String getText(HttpServletRequest req, HttpServletResponse res){
		String result = "";
		DataEntity[] data = null;
		String arcMenu = req.getParameter("arcMenu");
		String arcCate = req.getParameter("arcCate");
		String arcTitleSel = req.getParameter("arcTitleSel");
		if("new".equals(arcTitleSel)){
			arcTitleSel = "";
		}
		MpickDao dao = MpickDao.getInstance();
		if(arcCate != null && !"".equals(arcCate) && !"null".equals(arcCate)){
			String[] arcCates = arcCate.split("[|]");
			if(arcCates.length == 3){
				data =  dao.getCommText(arcTitleSel);
				if(data != null && data.length > 0){
					result = (String)data[0].get("ar_text");
				}
			}
		}
		//이미지 리사이징 적용.
		result = result.replaceAll("<img ", "<img class=\"img-responsive\" ");
		return result;
	}
	
	public int delText(HttpServletRequest req, HttpServletResponse res){
		int result = 0;
		String arcCate = req.getParameter("arcCate2");
		String arcTitleSel = req.getParameter("arcTitleSel");
		String[] arcCates = arcCate.split("[|]");
		MpickDao dao = MpickDao.getInstance();
		if(!"new".equals(arcTitleSel) && arcCates.length == 3){
			result = dao.archiveCommText(arcCates[0], arcTitleSel);
		}
		return result;
	}
	
	/**
	 * 카테고리 저장.
	 * @param req
	 * @param res
	 * @return
	 */
	public int saveCate(HttpServletRequest req, HttpServletResponse res){
		int result = 1;
		MpickDao dao = MpickDao.getInstance();
		
		String menu = req.getParameter("menus");
		String cate = req.getParameter("cates");
		
		if(menu != null && !"".equals(menu)){
			String[] menus = menu.split(",");
			for(int i=0; i<menus.length; i++){
				String[] menuVals = menus[i].split("[|]");
				if(menuVals.length == 2){
					if(dao.insertCommMenus(i, menuVals[0], menuVals[1]) < 1){
						result = 0;
					}
				}
			}
		}
		if(cate != null && !"".equals(cate)){
			String[] cates = cate.split(",");
			for(int i=0; i<cates.length; i++){
				String[] cate1Vals = cates[i].split("[|]");
				if(cate1Vals.length == 2){
					if(dao.insertCommCates(i, cate1Vals[0], cate1Vals[1]) < 1){
						result = 0;
					}
				}
			}
		}
		
		return result;
	}
	
	public int delNSaveCate(HttpServletRequest req, HttpServletResponse res){
		MpickDao dao = MpickDao.getInstance();
		dao.deleteAllCommCates();
		this.modifTextCate(req, res);
		return saveCate(req, res);
	}
	
	/**
	 * 변경된 메뉴명, 카테고리명 각 글에 적용.
	 * @param req
	 * @param res
	 */
	private void modifTextCate(HttpServletRequest req, HttpServletResponse res){
		String[] menuChg = req.getParameterValues("menuChg");
		String[] cage1Chg = req.getParameterValues("cage1Chg");
		MpickDao dao = MpickDao.getInstance();
		
		if(menuChg != null && menuChg.length > 0){
			for(int i=0; i<menuChg.length; i++){
				String[] menus = menuChg[i].split(",");
				if(menus.length == 2){
					dao.updateCommMenu(menus[0], menus[1]);
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
						dao.updateCommCate(cate1s0[0], cate1s0[1], cate1s1[0], cate1s1[1]);
					}
				}
			}
		}
		
	}
	
}
