package mpick.ctrl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jm.com.JmProperties;
import jm.net.DataEntity;
import mpick.com.MpickDao;
import mpick.com.MpickParam;

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
			} else if(cmd.equals("shipXl")){
				String xlCmd = req.getParameter("xlCmd");
				String fileName = req.getParameter("fileName");
				if(( xlCmd != null && !xlCmd.equals("") ) && ( fileName != null && !fileName.equals("") )){
					JmProperties property = new JmProperties(MpickParam.property);
					File xlsPath = new File(property.get("xlsPath"));
					File file = new File(xlsPath, fileName);
					String retJson = "";
					
					int shNum = 0;
					int levNum = 0;
					int valNum= 0;
					
					try {
						FileInputStream inputStream = new FileInputStream(file);
						XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
						if(xlCmd.equals("workBook")){
							if(!"http://localhost:8080/Mypick".equals(MpickParam.hostUrl)){
								dao.deleteAllSh();
							}
							int sheetCn = workbook.getNumberOfSheets();
							retJson += "{\"sheetCnt\":"+sheetCn+"}";
						} else if(xlCmd.equals("insShip")){
							shNum = Integer.parseInt(req.getParameter("shipNum"));
							XSSFSheet sheet = workbook.getSheetAt(shNum);
							int rows = sheet.getLastRowNum()+1;
							if(rows>1){
								XSSFRow row1 = sheet.getRow(1);
								XSSFCell shipId = null;
								int cols = row1.getLastCellNum();
								if(cols == 5){
									shipId = row1.getCell(0);
									XSSFCell shipName = row1.getCell(1);
									XSSFCell shipUrl = row1.getCell(2);
									XSSFCell wUnit = row1.getCell(3);
									XSSFCell aUnit = row1.getCell(4);
									
									retJson += "{";
									retJson += "\"shipId\":\""+shipId+"\",";
									retJson += "\"shipName\":\""+shipName+"\",";
									retJson += "\"shipUrl\":\""+shipUrl+"\",";
									retJson += "\"wUnit\":\""+wUnit+"\",";
									retJson += "\"aUnit\":\""+aUnit+"\",";
									retJson += "\"levs\":\""+(rows-3)+"\",";
									retJson += "\"rows\":\""+rows+"\",";
									retJson += "\"levNames\":[";
									for(int lv=3; lv<rows; lv++){
										XSSFRow lnRow = sheet.getRow(lv);
										if(lnRow != null){
											XSSFCell levName = lnRow.getCell(0);
											if(levName != null){
												retJson += "\""+levName.toString()+"\"";
											} else {
												retJson += "\""+"!등급오류!"+"\"";
											}
										} else {
											retJson += "\""+"!등급오류!"+"\"";
										}
										if(lv < (rows-1)){
											retJson += ",";
										}
									}
									retJson += "]";
									retJson += "}";
									if(!"http://localhost:8080/Mypick".equals(MpickParam.hostUrl)){
										dao.insertShMain(shNum, shipId.toString(), shipName.toString(), shipUrl.toString(), wUnit.toString(), aUnit.toString());
									}
								} else {
									retJson += (shNum+1)+"번 째 Sheet 오류 : ";
									retJson += "업체 정보가 불충분하거나 명확하지 않습니다. A2~E2 셀을 확인하세요.";
								}
							} else {
								retJson += (shNum+1)+"번 째 Sheet 오류 : ";
								retJson += "정보가 없습니다.";
							}
						} else if(xlCmd.equals("insLevs")){
							shNum = Integer.parseInt(req.getParameter("shipNum"));
							levNum = Integer.parseInt(req.getParameter("levNum"));
							XSSFSheet sheet = workbook.getSheetAt(shNum);
							int rows = sheet.getLastRowNum()+1;
							StringBuffer errMsg = new StringBuffer();
							if(rows>2){
								XSSFRow row1 = sheet.getRow(1);
								XSSFRow wRw = sheet.getRow(2);
								XSSFCell shipId = row1.getCell(0);
								retJson += "{";
								retJson += "\"shipId\":\""+shipId+"\",";
								XSSFRow row = sheet.getRow(levNum+3);
								int tCols = 0;
								if(row != null){
									int rcols = row.getLastCellNum();
									tCols = rcols-1;
									if(rcols > 1){
										XSSFCell levName = row.getCell(0);
										String levNameVal = "";
										if(levName != null){
											levNameVal = levName.toString();
										}
										retJson += "\"levName\":\""+levNameVal+"\",";
										if(levNameVal == null || "".equals(levNameVal)){
											tCols = 0;
											errMsg.append("전체");
										} else {
											if(!"http://localhost:8080/Mypick".equals(MpickParam.hostUrl)){
												dao.insertShLevs(shipId.toString(), levNum, levNameVal);
											}
											for(int cl=1; cl < rcols; cl++){
												valNum = cl;
												XSSFCell wCell = wRw.getCell(cl);
												XSSFCell cell = row.getCell(cl);
												if(wCell != null && cell != null){
													String vName = wCell.getRawValue();
													String vVal = cell.getRawValue();
													if((vName != null && !"".equals(vName)) && (vVal != null && !"".equals(vVal))){
														if(!"http://localhost:8080/Mypick".equals(MpickParam.hostUrl)){
															dao.insertShVals(shipId.toString(), levNum, vName, vVal);
														}
													} else {
														errMsg.append((valNum)+", ");
													}
												} else {
													errMsg.append((valNum)+", ");	
												}
											}
										}
									}
								} else {
									errMsg.append("전체");
								}
								retJson += "\"errMsg\":\""+errMsg.toString()+"\",";
								retJson += "\"valNums\":"+tCols+"";
								retJson += "}";
							} else {
								retJson += (levNum+1)+"번 째 등급 오류 : ";
								retJson += "정보가 없습니다.";
							}
						}
						
						/**
						 * 매번 수행이 될 때마다 토탈이 증가하면 자바외에 다른데서 메모리가 새는 것이고,
						 * 자바 메모리가 증가하면 수행 중인 자바 프로그램에서 메모리가 샌다고 보면 됩니다.
						 * 자바 프로그램에서 샌다면, 위에 답변된 것처럼 계속 참조할 필요가 없는 클래스가 다른 클래스에 의해 계속 참조가 되는지,
						 * static으로 선언된 Collection 클래스들이 정말 static이어야 하는지 다시 한번 살펴 보세요.
						 */
						/*
						long totalMemory = Runtime.getRuntime().totalMemory();
						long javaMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
						System.out.println("totalMemory:\t"+totalMemory + "\t\tjavaMemory:\t"+javaMemory);
						*/
					} catch (IOException e) {
						e.printStackTrace();
						StringBuffer errorMsg = new StringBuffer();
						errorMsg.append("오류 발생 : \n");
						errorMsg.append((shNum+1)+ "\t번째 Sheet \n");
						errorMsg.append((levNum+1)+ "\t번째 레벨\n");
						errorMsg.append((valNum)+"\t번째 값.\n");
						System.out.println(errorMsg.toString());
						out.print(errorMsg.toString());
					}
					out.println(retJson);
				}
			}
			
		}
		
	}
	
}
