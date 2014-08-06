package mpick.com;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import jm.com.JmProperties;
import jm.net.Dao;
import jm.net.DataEntity;

public class MpickDao {
	
	private static MpickDao instance = null;
	private JmProperties property = null;
	
	private MpickDao(){
		property = new JmProperties(MpickParam.property);
	}
	
	public static MpickDao getInstance() {
		if(instance == null){
			instance = new MpickDao();
		}
		return instance;
	}
	
	/**
	 *  request 로 부터 CandiUserObj 객체를 생성하는 메서드.
	 * @param req
	 * @return
	 */
	public MpickUserObj getUserObj(HttpServletRequest req){
		return getUserObj(req, new MpickUserObj());
	}
	
	/**
	 * request 로 부터 CandiUserObj 객체를 생성하는 메서드.
	 * @param req
	 * @param obj
	 * @return
	 */
	public MpickUserObj getUserObj(HttpServletRequest req, MpickUserObj obj){
		try {
			if(req.getParameter("email") != null)
				obj.setEmail(req.getParameter("email"));	
			if(req.getParameter("passwd") != null)
				obj.setPasswd(req.getParameter("passwd"));
			if(req.getParameter("name") != null)
				obj.setName(req.getParameter("name"));
			if(req.getParameter("nicname") != null)
				obj.setNicname(req.getParameter("nicname"));
			if(req.getParameter("birthY") != null && req.getParameter("birthM") != null && req.getParameter("birthD") != null){
				Date fullDate = new Date((new SimpleDateFormat("yyyyMMdd").parse(req.getParameter("birthY")+req.getParameter("birthM")+req.getParameter("birthD"))).getTime());
				obj.setBirthday(fullDate);
			}
			if(req.getParameter("gender") != null)
				obj.setGender(req.getParameter("gender"));
			if(req.getParameter("phone") != null)
				obj.setPhone(req.getParameter("phone"));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return obj;
	}
	
	/**
	 * CandiUserObj 객체를 DB에 저장.
	 * @param userObj
	 * @return
	 */
	public int insertUserObj(MpickUserObj userObj){
		int result = 0;
		
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		
		data.put("email", userObj.getEmail());
		data.put("passwd", userObj.getPasswd());
		data.put("name", userObj.getName());
		data.put("nicname", userObj.getNicname());
		data.put("birthday", userObj.getBirthday());
		data.put("gender", userObj.getGender());
		data.put("phone", userObj.getPhone());
		
		result = dao.inertData(property, "mp_user", data);
		return result;
	}
	
	/**
	 * CandiUserObj 객체를 DB에 업데이트.
	 * @param userObj
	 * @return
	 */
	public int updateUserObj(MpickUserObj userObj){
		int result = 0;
		
		Dao dao = Dao.getInstance();
		DataEntity setData = new DataEntity();
		setData.put("email", userObj.getEmail());
		setData.put("passwd", userObj.getPasswd());
		setData.put("name", userObj.getName());
		setData.put("nicname", userObj.getNicname());
		setData.put("birthday", userObj.getBirthday());
		setData.put("gender", userObj.getGender());
		setData.put("phone", userObj.getPhone());
		
		DataEntity whereData = new DataEntity();
		whereData.put("email", userObj.getEmail());
		
		result = dao.updateData(property, "mp_user", setData, whereData);
		
		return result;
	}
	
	/**
	 * 로그인 확인 메서드.
	 * 0:ID 없음, 1:PW오류, 2:로그인, 9:오류
	 * @param id
	 * @param passwd
	 * @return
	 */
	public int login(String email, String passwd) {
		Dao dao = Dao.getInstance();
		
		StringBuffer sql = new StringBuffer();
		String tempPw = "";
		String[] param = {email};
		int result = 9;
		
		sql.append("SELECT passwd FROM mp_user WHERE email = ?");
		
		DataEntity[] entity = dao.getResult(property, sql.toString(), param);
		
		if(entity != null && entity.length == 1){
			tempPw = (String)entity[0].get("passwd");
			if (tempPw.equals(passwd)) {
				result = 2;
			} else {
				result = 1;
			}
		} else { 
			result = 0;
		}
		return result;
	}
	
	/**
	 * id 값을 가지고 사용자 DB를 검색해서 MpickUserObj 를 리턴하는 메서드. 
	 * @param id
	 * @return
	 */
	public MpickUserObj getUserObj(String email) {
		MpickUserObj result = new MpickUserObj();
		
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		String[] param = {email};
		
		sql.append("SELECT ");
		sql.append("email, passwd, name, nicname, birthday, gender, phone, point, state ");
		sql.append("FROM mp_user ");
		sql.append("WHERE email = ?");
		
		DataEntity[] entity = dao.getResult(property, sql.toString(), param);
		
		if(entity != null && entity.length == 1){
			result.setEmail((String)entity[0].get("email"));
			result.setPasswd((String)entity[0].get("passwd"));
			result.setName((String)entity[0].get("name"));
			result.setNicname((String)entity[0].get("nicname"));
			result.setBirthday((Date)entity[0].get("birthday"));
			result.setGender((String)entity[0].get("gender"));
			result.setPhone((String)entity[0].get("phone"));
			result.setPoint((Integer)entity[0].get("point"));
			result.setState((String)entity[0].get("state"));
		}
		
		return result;
	}
	
	/**
	 * 이메일 중복여부 확인
	 * @param email
	 * @return
	 */
	public boolean isExistMail(String email) {
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		String[] param = {email};
		sql.append("SELECT count(*) as cnt FROM mp_user WHERE email = ?");
		int cnt = dao.getCount(property, sql.toString(), param);
		
		if (cnt == 0) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * 닉네임 중복여부 확인
	 * @param email
	 * @return
	 */
	public boolean isExistNicname(String nicname) {
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		String[] param = {nicname};
		sql.append("SELECT count(*) as cnt FROM mp_user WHERE nicname = ?");
		int cnt = dao.getCount(property, sql.toString(), param);
		
		if (cnt == 0) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * 환율정보 리턴.
	 * @return
	 */
	public DataEntity[] getCurrInfo(){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_curr_rate order by onum");
		data = dao.getResult(property, sql.toString(), null);
		return data;
	}
	
	/**
	 * 배송대행업체 메인 입력.
	 * @param shipId
	 * @param ShipName
	 * @param shipUrl
	 * @return
	 */
	public int insertShip(int onum, String shipId, String ShipName, String shipUrl ){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("onum", onum);
		data.put("ship_id", shipId);
		data.put("ship_name", ShipName);
		data.put("ship_url", shipUrl);
		result = dao.inertData(property, "mp_ship", data);
		return result;
	}
	
	/**
	 * 배송대행업체 레벨 입력.
	 * @param shipId
	 * @param levNum
	 * @param levName
	 * @param levVal
	 * @param levUnit
	 * @return
	 */
	public int insertShipLevs(String shipId, int levNum, String levName, String levVal, String levUnit ){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("ship_id", shipId);
		data.put("lev_num", levNum);
		data.put("lev_name", levName);
		data.put("lev_val", levVal);
		data.put("lev_unit", levUnit);
		result = dao.inertData(property, "mp_ship_levs", data);
		return result;
	}
	
	/**
	 * 배송대행업체 전체 삭제
	 */
	public void deleteAllShips(){
		Dao dao = Dao.getInstance();
		dao.deleteAll(property, "mp_ship");
		dao.deleteAll(property, "mp_ship_levs");
	}
	
	/**
	 * 배송대행업체 불러오기
	 * @return
	 */
	public DataEntity[] getShips(){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_ship order by onum");
		data = dao.getResult(property, sql.toString(), null);
		return data;
	}
	
	/**
	 * 배송대행업체 등급 불러오기.
	 * @param shipId
	 * @return
	 */
	public DataEntity[] getShipLevs(String shipId){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_ship_levs where ship_id = ? order by lev_num");
		String[] params = {shipId};
		data = dao.getResult(property, sql.toString(), params);
		return data;
	}
	
	/**
	 * 정보 저장.
	 * @param userMail
	 * @param encType
	 * @param encText
	 * @return
	 */
	public int insertArticle(String userMail, String menu, String cate1, String cate2, String title, String encText ){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("ar_menu_id", menu);
		data.put("ar_cate_1", cate1);
		data.put("ar_cate_2", cate2);
		data.put("ar_title", title);
		data.put("ar_text", encText);
		data.put("ar_mail", userMail);
		data.put("ar_state", "ACTIVE");
		result = dao.inertData(property, "mp_article", data);
		return result;
	}
	
	/**
	 * 이전 정보 상태 변경.
	 */
	public int archiveArticle(String menu, String cate1, String cate2, String title){
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("UPDATE mp_article SET ar_state = 'ARCHIVE' \n");
		sql.append("where ar_menu_id = ? \n");
		sql.append("and ar_cate_1 = ? \n");
		sql.append("and ar_cate_2 = ? \n");
		sql.append("and ar_title = ? \n");
		String[] params = {menu, cate1, cate2, title};
		return dao.updateSql(property, sql.toString(), params);
	}
	
	
	public int updateArcMenu(String menu, String new_menu){
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("UPDATE mp_article  \n");
		sql.append("SET ar_menu_id = ? \n");
		sql.append("where ar_menu_id = ? \n");
		String[] params = {new_menu, menu };
		return dao.updateSql(property, sql.toString(), params);
	}
	
	public int updateArcCate1(String menu, String cate1, String new_menu, String new_cate1){
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("UPDATE mp_article  \n");
		sql.append("SET ar_menu_id = ? \n");
		sql.append(", ar_cate_1 = ? \n");
		sql.append("where ar_menu_id = ? \n");
		sql.append("and ar_cate_1 = ? \n");
		String[] params = {new_menu, new_cate1, menu, cate1 };
		return dao.updateSql(property, sql.toString(), params);
	}
	
	public int updateArcCate2(String menu, String cate1, String cate2, String new_menu, String new_cate1, String new_cate2){
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("UPDATE mp_article  \n");
		sql.append("SET ar_menu_id = ? \n");
		sql.append(", ar_cate_1 = ? \n");
		sql.append(", ar_cate_2 = ? \n");
		sql.append("where ar_menu_id = ? \n");
		sql.append("and ar_cate_1 = ? \n");
		sql.append("and ar_cate_2 = ? \n");
		String[] params = {new_menu, new_cate1, new_cate2, menu, cate1, cate2 };
		return dao.updateSql(property, sql.toString(), params);
	}
	
	/**
	 * 내용 불러오기
	 * @param type
	 * @return
	 */
	public DataEntity[] getArticle(String menu, String cate1, String cate2, String title){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_article ");
		sql.append("where ar_state = 'ACTIVE' ");
		sql.append("and ar_menu_id = ? \n");
		sql.append("and ar_cate_1 = ? \n");
		sql.append("and ar_cate_2 = ? \n");
		sql.append("and ar_title = ? \n");
		String[] params = {menu, cate1, cate2, title};
		data = dao.getResult(property, sql.toString(), params);
		return data;
	}
	
	/**
	 * 제목 목록 불러오기
	 * @param menu
	 * @param cate1
	 * @param cate2
	 * @return
	 */
	public DataEntity[] getArcTitles(String menu, String cate1, String cate2){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT ar_title FROM mp_article ");
		sql.append("where ar_state = 'ACTIVE' ");
		sql.append("and ar_menu_id = ? \n");
		sql.append("and ar_cate_1 = ? \n");
		sql.append("and ar_cate_2 = ? \n");
		sql.append("order by ar_date \n");
		String[] params = {menu, cate1, cate2};
		data = dao.getResult(property, sql.toString(), params);
		return data;
	}
	
	/**
	 * 메뉴 저장
	 * @param arOrd
	 * @param arMenuId
	 * @param arMenuName
	 * @return
	 */
	public int insertMenus(int arOrd, String arMenuId, String arMenuName){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("ar_ord", arOrd);
		data.put("ar_menu_id", arMenuId);
		data.put("ar_menu_name", arMenuName);
		result = dao.inertData(property, "mp_ar_menu", data);
		return result;
	}
	
	/**
	 * 카테고리 1 저장.
	 * @param arOrd
	 * @param arMenuId
	 * @param arCateName
	 * @return
	 */
	public int insertCate1(int arOrd, String arMenuId, String arCateName){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("ar_ord", arOrd);
		data.put("ar_menu_id", arMenuId);
		data.put("ar_cate_name", arCateName);
		result = dao.inertData(property, "mp_ar_cate_1", data);
		return result;
	}
	
	/**
	 * 카테고리 2 저장.
	 * @param arOrd
	 * @param arMenuId
	 * @param arCate1
	 * @param arCateName
	 * @return
	 */
	public int insertCate2(int arOrd, String arMenuId, String arCate1, String arCateName){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("ar_ord", arOrd);
		data.put("ar_menu_id", arMenuId);
		data.put("ar_cate_1", arCate1);
		data.put("ar_cate_name", arCateName);
		result = dao.inertData(property, "mp_ar_cate_2", data);
		return result;
	}
	
	/**
	 * 카테고리 전체 삭제
	 */
	public void deleteAllCates(){
		Dao dao = Dao.getInstance();
		dao.deleteAll(property, "mp_ar_menu");
		dao.deleteAll(property, "mp_ar_cate_1");
		dao.deleteAll(property, "mp_ar_cate_2");
	}
	
	/**
	 * 메뉴 불러오기.
	 * @return
	 */
	public DataEntity[] getMenu(){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_ar_menu order by ar_ord ");
		data = dao.getResult(property, sql.toString(), null);
		return data;
	}
	
	/**
	 * 카테고리 1 불러오기.
	 * @param menu
	 * @return
	 */
	public DataEntity[] getCate1(String menu){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		
		if(menu == null || "".equals(menu)){
			sql.append("SELECT * FROM mp_ar_cate_1 order by ar_ord ");
			data = dao.getResult(property, sql.toString(), null);
		} else {
			sql.append("SELECT * FROM mp_ar_cate_1 WHERE ar_menu_id = ? order by ar_ord ");
			String[] param = { menu };
			data = dao.getResult(property, sql.toString(), param);
		}
		return data;
	}
	
	/**
	 * 카테고리 2 불러오기.
	 * @param menu
	 * @param cate1
	 * @return
	 */
	public DataEntity[] getCate2(String menu, String cate1){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		
		if(menu == null || "".equals(menu)){
			if(cate1 == null || "".equals(cate1)){
				sql.append("SELECT * FROM mp_ar_cate_2 order by ar_ord ");
				data = dao.getResult(property, sql.toString(), null);
			} else {
				sql.append("SELECT * FROM mp_ar_cate_2 WHERE ar_cate_1 = ? order by ar_ord ");
				String[] param = { cate1 };
				data = dao.getResult(property, sql.toString(), param);
			}
		} else {
			if(cate1 == null || "".equals(cate1)){
				sql.append("SELECT * FROM mp_ar_cate_2 WHERE ar_menu_id = ? order by ar_ord ");
				String[] param = { menu };
				data = dao.getResult(property, sql.toString(), param);
			} else {
				sql.append("SELECT * FROM mp_ar_cate_2 WHERE ar_menu_id = ? AND ar_cate_1 = ? order by ar_ord ");
				String[] param = { menu, cate1 };
				data = dao.getResult(property, sql.toString(), param);
			}
		}
		return data;
	}
	
	/**
	 * 배송대행업체 엑셀 메인 입력.
	 * @param onum
	 * @param shipId
	 * @param ShipName
	 * @param shipUrl
	 * @param wUnit
	 * @param aUnit
	 * @return
	 */
	public int insertShMain(int onum, String shipId, String shipName, String shipUrl, String wUnit, String aUnit){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("onum", onum);
		data.put("ship_id", shipId);
		data.put("ship_name", shipName);
		data.put("ship_url", shipUrl);
		data.put("wunit", wUnit);
		data.put("aunit", aUnit);
		result = dao.inertData(property, "mp_sh_main", data);
		return result;
	}
	
	/**
	 * 배송대행업체 엑셀 레벨 입력.
	 * @param shipId
	 * @param levNum
	 * @param levName
	 * @return
	 */
	public int insertShLevs(String shipId, int levNum, String levName){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("ship_id", shipId);
		data.put("lev_num", levNum);
		data.put("lev_name", levName);
		result = dao.inertData(property, "mp_sh_levs", data);
		return result;
	}
	
	/**
	 * 배송대행업체 엑셀 레벨 입력.
	 * @param shipId
	 * @param levNum
	 * @param levName
	 * @return
	 */
	public int insertShVals(String shipId, int levNum, String valWeight, String valAmount){
		int result = 0;
		DataEntity data = new DataEntity();
		Dao dao = Dao.getInstance();
		data.put("ship_id", shipId);
		data.put("lev_num", levNum);
		data.put("val_weight", valWeight);
		data.put("val_amount", valAmount);
		result = dao.inertData(property, "mp_sh_vals", data);
		return result;
	}
	
	/**
	 * 배송대행업체 전체 삭제
	 */
	public void deleteAllSh(){
		Dao dao = Dao.getInstance();
		dao.deleteAll(property, "mp_sh_main");
		dao.deleteAll(property, "mp_sh_levs");
		dao.deleteAll(property, "mp_sh_vals");
	}
	
	/**
	 * 배송대행업체 불러오기
	 * @return
	 */
	public DataEntity[] getShMain(){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_sh_main order by onum");
		data = dao.getResult(property, sql.toString(), null);
		return data;
	}
	public DataEntity[] getShMain(String shipId){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_sh_main where ship_id = ? order by onum");
		String[] params = {shipId};
		data = dao.getResult(property, sql.toString(), params);
		return data;
	}
	/**
	 * 배송대행업체 등급 불러오기.
	 * @param shipId
	 * @return
	 */
	public DataEntity[] getShLevs(String shipId){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_sh_levs where ship_id = ? order by lev_num");
		String[] params = {shipId};
		data = dao.getResult(property, sql.toString(), params);
		return data;
	}
	
	/**
	 * 배송대행업체 값 불러오기.
	 * @param shipId
	 * @param levName
	 * @return
	 */
	public DataEntity[] getShVals(String shipId, String levNum){
		DataEntity[] data = null;
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM mp_sh_vals where ship_id = ? and lev_num = ? order by val_weight");
		String[] params = {shipId, levNum};
		data = dao.getResult(property, sql.toString(), params);
		return data;
	}
}