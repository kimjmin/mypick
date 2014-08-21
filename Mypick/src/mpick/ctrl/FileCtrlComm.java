package mpick.ctrl;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONObject;

import jm.com.JmProperties;
import mpick.com.MpickParam;

public class FileCtrlComm extends HttpServlet {
	
	private static final long serialVersionUID = 202287092079292751L;
	private JmProperties property = null;
	private File commPath;
	
	public void init() {
		property = new JmProperties(MpickParam.property);
	}
	
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		res.setContentType("text/html; charset=UTF-8");
		
		HttpSession session = req.getSession();
		String commUri = (String)session.getAttribute("commUri");
		String commWriter = (String)session.getAttribute("commWriter");
		if(commUri != null){
			if(commUri.indexOf("/Write") > -1){
				commUri = commUri.substring(commUri.lastIndexOf("Write"));
				commUri = commUri.replaceAll("Write","");
				commUri = commUri.replaceAll("/","");
			} else if(commUri.indexOf("/View") > -1){
				commUri = commUri.substring(commUri.lastIndexOf("View"));
				commUri = commUri.replaceAll("View","");
				commUri = commUri.replaceAll("/","");
			}
		}
		if(commUri == null || "".equals(commUri)) commUri = "temp";
		commPath = new File(property.get("commPath") + "/"+commWriter+"/"+commUri);
		
		String uri = req.getRequestURI();
		uri = uri.substring(uri.lastIndexOf("File")+4);
		uri = uri.replaceAll("/", "");
		if (uri != null  && !uri.isEmpty()) {
			File file = new File(commPath, uri);
			if (file.exists()) {
				int bytes = 0;
				ServletOutputStream op = res.getOutputStream();
				
				res.setContentType(getMimeType(file));
				res.setContentLength((int) file.length());
				res.setHeader( "Content-Disposition", "inline; filename=\"" + file.getName() + "\"" );
				
				byte[] bbuf = new byte[1024];
				DataInputStream in = new DataInputStream(new FileInputStream(file));
				
				while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
					op.write(bbuf, 0, bytes);
				}
				
				in.close();
				op.flush();
				op.close();
			}
		} else {
			getFileList(req, res);
		}
	}
	
	private void getFileList(HttpServletRequest req, HttpServletResponse res) throws IOException{
		res.setContentType("text/html; charset=UTF-8");
		String url = req.getRequestURL().toString();
		PrintWriter out = res.getWriter();
		res.setContentType("application/json");
		File tempPath = new File( (commPath + "/").replaceAll("//","/") );
		if(!tempPath.exists()){
			tempPath.mkdirs(); 
		}
		File[] items = tempPath.listFiles();
		JSONObject jsonf = new JSONObject();
		JSONArray json = new JSONArray();
		try {
			for (File item : items) {
				JSONObject jsono = new JSONObject();
				jsono.put("name", item.getName());
				jsono.put("size", item.length());
				jsono.put("url", url+"/" + item.getName());
				jsono.put("appendUrl", url+"?appfile=" + item.getName());
				jsono.put("deleteUrl", url+"?file=" + item.getName());
				jsono.put("deleteType", "DELETE");
				json.put(jsono);
			}
			jsonf.put("files", json);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			out.write(jsonf.toString());
			out.close();
		}
		
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		res.setContentType("text/html; charset=UTF-8");
		
		HttpSession session = req.getSession();
		String commUri = (String)session.getAttribute("commUri");
		String commWriter = (String)session.getAttribute("commWriter");
		if(commUri != null){
			if(commUri.indexOf("/Write") > -1){
				commUri = commUri.substring(commUri.lastIndexOf("Write"));
				commUri = commUri.replaceAll("Write","");
				commUri = commUri.replaceAll("/","");
			} else if(commUri.indexOf("/View") > -1){
				commUri = commUri.substring(commUri.lastIndexOf("View"));
				commUri = commUri.replaceAll("View","");
				commUri = commUri.replaceAll("/","");
			}
		}
		if(commUri == null || "".equals(commUri)) commUri = "temp";
		commPath = new File(property.get("commPath") + "/"+commWriter+"/"+commUri);
		
		String url = req.getRequestURL().toString();
		PrintWriter out = res.getWriter();
		res.setContentType("application/json");
		if (!ServletFileUpload.isMultipartContent(req)) {
			throw new IllegalArgumentException("Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		// filePath/<id>/ 경로에 파일 업로드.
		File tempPath = new File( (commPath + "/").replaceAll("//","/") );
		if(!tempPath.exists()){
			tempPath.mkdirs();
		}
		ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());
		JSONObject jsonf = new JSONObject();
		JSONArray json = new JSONArray();
		try {
			List<FileItem> items = uploadHandler.parseRequest(req);
			for (FileItem item : items) {
				if (!item.isFormField()) {
					File file = new File(tempPath, item.getName());
					item.write(file);
					JSONObject jsono = new JSONObject();
					jsono.put("name", item.getName());
					jsono.put("size", item.getSize());
					jsono.put("url", url+"/" + item.getName());
					jsono.put("appendUrl", url+"?appfile=" + item.getName());
					jsono.put("deleteUrl", url+"?file=" + item.getName());
					jsono.put("deleteType", "DELETE");
					json.put(jsono);
				}
			}
			jsonf.put("files", json);
		} catch (FileUploadException e) {
			throw new RuntimeException(e);
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			out.write(jsonf.toString());
			out.close();
		}
	}
	
	public void doDelete(HttpServletRequest req, HttpServletResponse res) throws IOException{
		res.setContentType("application/json");
		String[] files_name = req.getParameterValues("file");
		File tempPath = new File( (commPath + "/").replaceAll("//","/") );
		for(String file_name : files_name){
			File file = new File( tempPath + "/" + file_name );
			if( file.exists() ) file.delete();
		}
		getFileList(req, res);
	}
	
	private String getMimeType(File file) {
		String mimetype = "";
		if (file.exists()) {
			if (getSuffix(file.getName()).equalsIgnoreCase("png")) {
				mimetype = "image/png";
			} else {
				javax.activation.MimetypesFileTypeMap mtMap = new javax.activation.MimetypesFileTypeMap();
				mimetype  = mtMap.getContentType(file);
			}
		}
		return mimetype;
	}
	
	private String getSuffix(String filename) {
		String suffix = "";
		int pos = filename.lastIndexOf('.');
		if (pos > 0 && pos < filename.length() - 1) {
			suffix = filename.substring(pos + 1);
		}
		return suffix;
	}
	
}
