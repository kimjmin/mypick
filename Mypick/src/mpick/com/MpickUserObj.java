package mpick.com;

import java.io.Serializable;

public class MpickUserObj implements Serializable{
	
	private static final long serialVersionUID = 2736938902661911397L;
	
	private String id = "";
	private String passwd = "";
	private String name = "";
	private String type = "";
	
	public String getId() {
		return id;
	}
	public String getPasswd() {
		return passwd;
	}
	public String getName() {
		return name;
	}
	public String getType() {
		return type;
	}
	
	
	public void setId(String id) {
		this.id = id;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setType(String type) {
		this.type = type;
	}
	
}
