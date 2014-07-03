package mpick.ctrl;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Array;

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
				outStr.append("{\"curr_info\":[");
				
				for(int i=0; i<currData.length; i++){
					outStr.append("{");
					outStr.append("\"up_date\":\""+currData[i].get("up_date")+"\",");
					outStr.append("\"up_time\":\""+currData[i].get("up_time")+"\",");
					outStr.append("\"curr\":\""+currData[i].get("curr")+"\",");
					outStr.append("\"curr_kr\":\""+currData[i].get("curr_kr")+"\",");
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
				outStr.append("]}");
				out.print(outStr.toString());
			}
			
		}
		
	}
	
}
