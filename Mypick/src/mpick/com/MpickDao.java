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
		DataEntity whereData = new DataEntity();
		result = dao.updateData(property, "cdi_user", setData, whereData);
		
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
			result.setEmail((String)entity[0].get("id"));
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
	
}