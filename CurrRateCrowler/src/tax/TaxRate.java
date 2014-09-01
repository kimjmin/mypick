package tax;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

public class TaxRate {
	public static void main(String[] args) throws UnsupportedEncodingException, FileNotFoundException, IOException {
		// TODO Auto-generated method stub
		GetTaxRate taxRate = new GetTaxRate();
		taxRate.getInfo();
	}
}
