package mpick.ctrl;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jm.net.DataEntity;
import mpick.com.MpickDao;

public class MpickAjax extends HttpServlet{
	
	private static final long serialVersionUID = 8075039219880337611L;

	/**
	 * Candi 에서 사용하는 Ajax.
	 */
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		MpickDao dao = MpickDao.getInstance();
		String cmd = req.getParameter("cmd");
		if(cmd != null){
			/**
			 * 중복 ID 체크.
			 */
			if(cmd.equals("checkMail")){
				String email = req.getParameter("email");
				if(!dao.isExistMail(email)){
					out.print("{\"result\":\"OK\"}");
				} else {
					out.print("{\"result\":\"EXIST\"}");
				}
			} else if(cmd.equals("checkNick")){
				String nicname = req.getParameter("nicname");
				if(!dao.isExistNicname(nicname)){
					out.print("{\"result\":\"OK\"}");
				} else {
					out.print("{\"result\":\"EXIST\"}");
				}
			} else if(cmd.equals("currInfo")){
				DataEntity[] currData = dao.getCurrInfo();
				StringBuffer outStr = new StringBuffer();
				outStr.append("{");
				outStr.append("\"up_date\":\""+currData[0].get("up_date")+"\",");
				outStr.append("\"up_time\":\""+currData[0].get("up_time")+"\",");
				outStr.append("\"curr_head\":[");
				for(int i=0; i<currData.length; i++){
					outStr.append("{");
					outStr.append("\"curr\":\""+currData[i].get("curr")+"\",");
					outStr.append("\"curr_kr\":\""+currData[i].get("curr_kr")+"\"");
					outStr.append("}");
					if(i < currData.length-1){ outStr.append(","); }
				}
				outStr.append("],");
				outStr.append("\"curr_info\":{");
				for(int i=0; i<currData.length; i++){
					outStr.append("\""+currData[i].get("curr")+"\":{");
					outStr.append("\"cash_buy\":"+currData[i].get("cash_buy")+",");
					outStr.append("\"cash_buy_rate\":"+currData[i].get("cash_buy_rate")+",");
					outStr.append("\"cash_sell\":"+currData[i].get("cash_sell")+",");
					outStr.append("\"cash_sell_rate\":"+currData[i].get("cash_sell_rate")+",");
					outStr.append("\"trans_send\":"+currData[i].get("trans_send")+",");
					outStr.append("\"trans_receive\":"+currData[i].get("trans_receive")+",");
					outStr.append("\"tc_buy\":"+currData[i].get("tc_buy")+",");
					outStr.append("\"check_sell\":"+currData[i].get("check_sell")+",");
					outStr.append("\"sell_refer\":"+currData[i].get("sell_refer")+",");
					outStr.append("\"disc_rate\":"+currData[i].get("disc_rate")+",");
					outStr.append("\"usd_rate\":"+currData[i].get("usd_rate")+"");
					outStr.append("}");
					if(i < currData.length-1){ outStr.append(","); }
				}
				outStr.append("}");
				outStr.append("}");
				out.print(outStr.toString());
			} else if(cmd.equals("shipInfo")){
				String shipId = req.getParameter("shipId");
				DataEntity[] shipMain = dao.getShMain(shipId);
				StringBuffer outStr = new StringBuffer();
				outStr.append("{");
				if(shipMain.length == 1){
					outStr.append("\"onum\":"+shipMain[0].get("onum")+",");
					outStr.append("\"ship_id\":\""+shipMain[0].get("ship_id")+"\",");
					outStr.append("\"ship_name\":\""+shipMain[0].get("ship_name")+"\",");
					outStr.append("\"ship_url\":\""+shipMain[0].get("ship_url")+"\",");
					outStr.append("\"wunit\":\""+shipMain[0].get("wunit")+"\",");
					outStr.append("\"aunit\":\""+shipMain[0].get("aunit")+"\",");
					outStr.append("\"ship_levs\":[");
					
					DataEntity[] shipLev = dao.getShLevs(shipId);
					for(int j=0; j < shipLev.length; j++){
						outStr.append("{");
						outStr.append("\"lev_num\":\""+shipLev[j].get("lev_num")+"\",");
						outStr.append("\"lev_name\":\""+shipLev[j].get("lev_name")+"\",");
						
						outStr.append("\"lev_vals\":[");
						DataEntity[] shipVals = dao.getShVals(shipId,shipLev[j].get("lev_num")+"");
						for(int k=0; k < shipVals.length; k++){
							outStr.append("{");
							outStr.append("\"val_weight\":"+shipVals[k].get("val_weight")+",");
							outStr.append("\"val_amount\":"+shipVals[k].get("val_amount")+"");
							outStr.append("}");
							if(k < shipVals.length-1){ outStr.append(","); }
						}
						outStr.append("]");	
						
						outStr.append("}");
						if(j < shipLev.length-1){ outStr.append(","); }
					}
					
					outStr.append("]");	
				}
				outStr.append("}");
				out.print(outStr.toString());
			} else if(cmd.equals("cateInfo")){
				DataEntity[] menuData = dao.getMenu();
				DataEntity[] cate1Data = dao.getCate1(null);
				DataEntity[] cate2Data = dao.getCate2(null, null);
				StringBuffer outStr = new StringBuffer();
				outStr.append("{");
				
				outStr.append("\"menu_info\":[");
				for(int i=0; i < menuData.length; i++){
					outStr.append("{");
					outStr.append("\"menu_id\":\""+menuData[i].get("ar_menu_id")+"\",");
					outStr.append("\"menu_name\":\""+menuData[i].get("ar_menu_name")+"\"");
					outStr.append("}");
					if(i < menuData.length-1){ outStr.append(","); }
				}
				outStr.append("]");
				outStr.append(",");
				
				outStr.append("\"cate1_info\":[");
				for(int i=0; i < cate1Data.length; i++){
					outStr.append("{");
					outStr.append("\"menu_id\":\""+cate1Data[i].get("ar_menu_id")+"\",");
					outStr.append("\"cate_name\":\""+cate1Data[i].get("ar_cate_name")+"\"");
					outStr.append("}");
					if(i < cate1Data.length-1){ outStr.append(","); }
				}
				outStr.append("]");
				outStr.append(",");
				
				outStr.append("\"cate2_info\":[");
				for(int i=0; i < cate2Data.length; i++){
					outStr.append("{");
					outStr.append("\"menu_id\":\""+cate2Data[i].get("ar_menu_id")+"\",");
					outStr.append("\"cate_1_name\":\""+cate2Data[i].get("ar_cate_1")+"\",");
					outStr.append("\"cate_2_name\":\""+cate2Data[i].get("ar_cate_name")+"\"");
					outStr.append("}");
					if(i < cate2Data.length-1){ outStr.append(","); }
				}
				outStr.append("]");
				
				outStr.append("}");
				out.print(outStr.toString());
			} else if(cmd.equals("arcCateInfo")){
				DataEntity[] menuData = dao.getMenu();
				StringBuffer outStr = new StringBuffer();
				outStr.append("{");
				
				outStr.append("\"menu_info\":[");
				for(int i=0; i < menuData.length; i++){
					outStr.append("{");
					outStr.append("\"menu_id\":\""+menuData[i].get("ar_menu_id")+"\",");
					outStr.append("\"menu_name\":\""+menuData[i].get("ar_menu_name")+"\",");
					
					outStr.append("\"cate1_info\":[");
					DataEntity[] cate1Data = dao.getCate1((String)menuData[i].get("ar_menu_id"));
					for(int j=0; j< cate1Data.length; j++){
						outStr.append("{");
						outStr.append("\"menu_id\":\""+cate1Data[j].get("ar_menu_id")+"\",");
						outStr.append("\"cate_name\":\""+cate1Data[j].get("ar_cate_name")+"\",");
						
						outStr.append("\"cate2_info\":[");
						DataEntity[] cate2Data = dao.getCate2((String)cate1Data[j].get("ar_menu_id"), (String)cate1Data[j].get("ar_cate_name"));
						for(int k=0; k < cate2Data.length; k++){
							outStr.append("{");
							outStr.append("\"menu_id\":\""+cate2Data[k].get("ar_menu_id")+"\",");
							outStr.append("\"cate_1_name\":\""+cate2Data[k].get("ar_cate_1")+"\",");
							outStr.append("\"cate_2_name\":\""+cate2Data[k].get("ar_cate_name")+"\",");
							
							outStr.append("\"title_info\":[");
							DataEntity[] titles = dao.getArcTitles((String)cate2Data[k].get("ar_menu_id"), (String)cate2Data[k].get("ar_cate_1"), (String)cate2Data[k].get("ar_cate_name"));
							for(int l=0; l< titles.length; l++){
								outStr.append("{");
								outStr.append("\"title\":\""+titles[l].get("ar_title")+"\"");
								outStr.append("}");
								if(l < titles.length-1){ outStr.append(","); }
								
							}
							outStr.append("]");
							outStr.append("}");
							if(k < cate2Data.length-1){ outStr.append(","); }
						}
						outStr.append("]");
						outStr.append("}");
						if(j < cate1Data.length-1){ outStr.append(","); }
					}
					outStr.append("]");
					outStr.append("}");
					if(i < menuData.length-1){ outStr.append(","); }
				}
				outStr.append("]");
				
				outStr.append("}");
				out.print(outStr.toString());
			} else if(cmd.equals("arcText")){
				Article arc = new Article();
				out.print(arc.getArticle(req, res));
			}
			
		}
		
	}
	
}
