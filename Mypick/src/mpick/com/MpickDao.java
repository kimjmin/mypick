package mpick.com;

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
		
		if(req.getParameter("id") != null)
			obj.setId(req.getParameter("id").trim());
		if(req.getParameter("passwd") != null)
			obj.setPasswd(req.getParameter("passwd"));
		if(req.getParameter("name") != null)
			obj.setName(req.getParameter("name"));
		if(req.getParameter("type") != null)
			obj.setType(req.getParameter("type"));
		
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
		
		data.put("id", userObj.getId());
		data.put("passwd", userObj.getPasswd());
		data.put("name", userObj.getName());
		data.put("type", userObj.getType());
		
		result = dao.inertData(property, "cdi_user", data);
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
		
		setData.put("passwd", userObj.getPasswd());
		if(!"".equals(userObj.getName()))
			setData.put("name", userObj.getName());
		if(!"".equals(userObj.getType()))
			setData.put("type", userObj.getType());
		
		whereData.put("id", userObj.getId());
		
		result = dao.updateData(property, "cdi_user", setData, whereData);
		
		return result;
	}
	
	/**
	 * ID 중복 여부 확인하는 메서드.
	 * 0:ID 없음, 1:PW오류, 2:로그인, 9:오류
	 * @param id
	 * @param passwd
	 * @return
	 */
	public int login(String id, String passwd) {
		Dao dao = Dao.getInstance();
		
		StringBuffer sql = new StringBuffer();
		String tempPw = "";
		String[] param = {id};
		int result = 9;
		
		sql.append("SELECT passwd FROM cdi_user WHERE id = ?");
		
		DataEntity[] entity = dao.getResult(property, sql.toString(), param);
		
		if(entity != null && entity.length == 1){
			tempPw = entity[0].get("passwd");
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
	 * id 값을 가지고 사용자 DB를 검색해서 CandiUserObj 를 리턴하는 메서드. 
	 * @param id
	 * @return
	 */
	public MpickUserObj getUserObj(String id) {
		MpickUserObj result = new MpickUserObj();
		
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		String[] param = {id};
		
		sql.append("SELECT ");
		sql.append("id, passwd, name, type ");
		sql.append("FROM cdi_user ");
		sql.append("WHERE id = ?");
		
		DataEntity[] entity = dao.getResult(property, sql.toString(), param);
		
		if(entity != null && entity.length == 1){
			result.setId(entity[0].get("id"));
			result.setPasswd(entity[0].get("passwd"));
			result.setName(entity[0].get("name"));
			result.setType(entity[0].get("type"));
		}
		
		return result;
	}
	
	/**
	 * ID 중복여부 확인
	 * @param id
	 * @return
	 */
	public boolean isExistId(String id) {
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		String[] param = {id};
		sql.append("SELECT count(*) as cnt FROM cdi_user WHERE id = ?");
		int cnt = dao.getCount(property, sql.toString(), param);
		
		if (cnt == 0) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * 사업자 목록을 가져오는 쿼리.
	 * @return
	 */
	public DataEntity[] getOspList(){
		DataEntity[] result = null;
		
		Dao dao = Dao.getInstance();
		StringBuffer sql = new StringBuffer();
		String[] param = {"osp"};
				
		sql.append("SELECT ");
		sql.append("id, name ");
		sql.append("FROM cdi_user ");
		sql.append("WHERE type = ?");
		
		result = dao.getResult(property, sql.toString(), param);
		
		return result;
	}
}
