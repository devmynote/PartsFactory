// dmd -J=. sample1.d codeconv.d
import charcodeconv;

void main()
{
	string s = "あか青　AZaz ";
	writeHex(s);
	
	string s2 = s.toSJIS;
	writeHex(s2);
	writeHex(s2.fromSJIS);
	
	s2 = s.toJIS;
	writeHex(s2);
	writeHex(s2.fromJIS);
	
	s2 = s.toEUC;
	writeHex(s2);
	writeHex(s2.fromEUC);
	
	s2 = "AZaz19ｱﾝ<> ".toEBCDIC;
	writeHex(s2);
	writeHex(s2.fromEBCDIC);
	
	s2 = "一９鸙煕　".toCP930;
	writeHex(s2);
	writeHex(s2.fromCP930);
}
