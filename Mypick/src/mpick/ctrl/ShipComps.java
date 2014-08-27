package mpick.ctrl;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mpick.com.MpickDao;

public class ShipComps {
	
	public int saveShipCompList(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, FileNotFoundException, IOException {
		String[] shipItemIds = req.getParameterValues("shipItemId");
		String[] shipItemNames = req.getParameterValues("shipItemName");
		String[] shipItemUrls = req.getParameterValues("shipItemUrl");
		int result = 0;
		if( (shipItemIds != null && shipItemNames != null && shipItemUrls != null) &&
				((shipItemIds.length > 0) && (shipItemIds.length == shipItemNames.length) && (shipItemIds.length == shipItemUrls.length))){
			MpickDao dao = MpickDao.getInstance();
			dao.deleteAllShips();
			for(int i=0; i<shipItemIds.length; i++){
				result += dao.insertShip(i, shipItemIds[i], shipItemNames[i], shipItemUrls[i]);
				
				String[] lvNames = req.getParameterValues("lvName_"+shipItemIds[i]);
				String[] lvVals = req.getParameterValues("lvVal_"+shipItemIds[i]);
				String[] lvUnits = req.getParameterValues("lvUnit_"+shipItemIds[i]);
				if( (shipItemIds != null && shipItemNames != null && shipItemUrls != null) &&
						((lvNames.length > 0) && (lvNames.length == lvVals.length) && (lvNames.length == lvUnits.length))){
					for(int j=0; j< lvNames.length; j++){
						result += dao.insertShipLevs(shipItemIds[i], j, lvNames[j], lvVals[j], lvUnits[j]);
					}
				}
			}
		}
		return result;
	}
}
