package mpick.com;

import java.io.Serializable;
import java.util.Date;

public class MpickUserObj implements Serializable{
	private static final long serialVersionUID = 2736938902661911397L;
	
	public String getEmail() {
		return email;
	}
	public String getPasswd() {
		return passwd;
	}
	public String getNicname() {
		return nicname;
	}
	public String getName() {
		return name;
	}
	public Date getBirthday() {
		return birthday;
	}
	public String getGender() {
		return gender;
	}
	public String getPhone() {
		return phone;
	}
	public int getPoint() {
		return point;
	}
	public String getState() {
		return state;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public void setNicname(String nicname) {
		this.nicname = nicname;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public void setState(String state) {
		this.state = state;
	}
	
	private String email = "";
	private String passwd = "";
	private String nicname = "";
	private String name = "";
	private Date birthday = null;
	private String gender = "";
	private String phone = "";
	private int point = 0;
	private String state = "";
	
}
