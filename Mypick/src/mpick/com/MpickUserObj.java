package mpick.com;

import java.io.Serializable;
import java.util.Date;

public class MpickUserObj implements Serializable{
	
	private static final long serialVersionUID = 2736938902661911397L;
	
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
