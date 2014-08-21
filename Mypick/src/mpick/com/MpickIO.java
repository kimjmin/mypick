package mpick.com;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.List;

import jm.com.JmProperties;

public class MpickIO {

	private static MpickIO instance = null;
	private JmProperties property = null;

	private MpickIO() {
		property = new JmProperties(MpickParam.property);
	}

	public static MpickIO getInstance() {
		if (instance == null) {
			instance = new MpickIO();
		}
		return instance;
	}
	
	public void moveFile(String properVal, String sourceVal, String destVal) {
		String sPath = property.get(properVal)+"/"+sourceVal;
		String dPath = property.get(properVal)+"/"+destVal;
		
		List<File> dirList = getDirFileList(sPath);
		if(dirList != null){
			File tempPath = new File((dPath + "/").replaceAll("//","/"));
			if(!tempPath.exists()){
				tempPath.mkdirs();
			}
			for (int i = 0; i < dirList.size(); i++) {
				String fileName = dirList.get(i).getName();
				fileCopy(sPath + "/" + fileName, dPath + "/" + fileName);
				fileDelete(sPath + "/" + fileName);
			}
		}
		
	}
	
	public void deleteFile(String properVal, String pathVal) {
		String path = property.get(properVal)+"/"+pathVal;
		List<File> dirList = getDirFileList(path);
		if(dirList != null){
			for (int i = 0; i < dirList.size(); i++) {
				String fileName = dirList.get(i).getName();
				fileDelete(path+"/"+fileName);
			}
		}
	}
	
	private List<File> getDirFileList(String dirPath) {
		List<File> dirFileList = null;
		File dir = new File(dirPath);
		if (dir.exists()) {
			File[] files = dir.listFiles();
			dirFileList = Arrays.asList(files);
		}
		return dirFileList;
	}
	
	private void fileCopy(String inFileName, String outFileName) {
		InputStream inStream = null;
		OutputStream outStream = null;
		try {
			File af =new File(inFileName);
			File bf =new File(outFileName);
			inStream = new FileInputStream(af);
			outStream = new FileOutputStream(bf);
			
			byte[] buffer = new byte[1024];
			int length;
			while ((length = inStream.read(buffer)) > 0){  
				outStream.write(buffer, 0, length);
			}
			inStream.close();
			outStream.close();
		} catch (IOException e){
			e.printStackTrace();
		}
	}

	private void fileDelete(String deleteFileName) {
		File I = new File(deleteFileName);
		I.delete();
	}
	
}
