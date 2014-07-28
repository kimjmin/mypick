package mpick.ctrl;

import java.awt.image.BufferedImage;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.imgscalr.Scalr;
import org.json.JSONArray;
import org.json.JSONObject;

import jm.com.JmProperties;
import mpick.com.MpickParam;

public class FileCtrl extends HttpServlet {
	
	private static final long serialVersionUID = 6553578554638094776L;
	private JmProperties property = null;
	private File fileUploadPath;
	
	public void init() {
		property = new JmProperties(MpickParam.property);
		fileUploadPath = new File(property.get("fileUpPath"));
	}
	
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		if (req.getParameter("getfile") != null  && !req.getParameter("getfile").isEmpty()) {
			File file = new File(fileUploadPath, req.getParameter("getfile"));
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
		} else if (req.getParameter("getthumb") != null && !req.getParameter("getthumb").isEmpty()) {
			File file = new File(fileUploadPath, req.getParameter("getthumb"));
				if (file.exists()) {
					String mimetype = getMimeType(file);
					if (mimetype.endsWith("png") || mimetype.endsWith("jpeg") || mimetype.endsWith("gif")) {
						BufferedImage im = ImageIO.read(file);
						if (im != null) {
							BufferedImage thumb = Scalr.resize(im, 75); 
							ByteArrayOutputStream os = new ByteArrayOutputStream();
							if (mimetype.endsWith("png")) {
								ImageIO.write(thumb, "PNG" , os);
								res.setContentType("image/png");
							} else if (mimetype.endsWith("jpeg")) {
								ImageIO.write(thumb, "jpg" , os);
								res.setContentType("image/jpeg");
							} else {
								ImageIO.write(thumb, "GIF" , os);
								res.setContentType("image/gif");
							}
							ServletOutputStream srvos = res.getOutputStream();
							res.setContentLength(os.size());
							res.setHeader( "Content-Disposition", "inline; filename=\"" + file.getName() + "\"" );
							os.writeTo(srvos);
							srvos.flush();
							srvos.close();
						}
					}
			}
		} else {
			getFileList(req, res);
		}
	}
	
	private void getFileList(HttpServletRequest req, HttpServletResponse res) throws IOException{
		String url = req.getRequestURL().toString();
		PrintWriter out = res.getWriter();
		res.setContentType("application/json");
		File tempPath = new File( (fileUploadPath + "/").replaceAll("//","/") );
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
				jsono.put("url", url+"?getfile=" + item.getName());
				jsono.put("thumbnailUrl", url+"?getthumb=" + item.getName());
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
		String url = req.getRequestURL().toString();
		PrintWriter out = res.getWriter();
		res.setContentType("application/json");
		if (!ServletFileUpload.isMultipartContent(req)) {
			throw new IllegalArgumentException("Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		// filePath/<id>/ 경로에 파일 업로드.
		File tempPath = new File( (fileUploadPath + "/").replaceAll("//","/") );
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
					jsono.put("url", url+"?getfile=" + item.getName());
					jsono.put("thumbnailUrl", url+"?getthumb=" + item.getName());
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
		File tempPath = new File( (fileUploadPath + "/").replaceAll("//","/") );
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
