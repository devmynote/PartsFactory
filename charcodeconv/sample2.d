// dmd -J=. sample2.d codeconv.d
import std.stdio;
import charcodeconv;

void main()
{
  string s1 = [0x82, 0xA0, 0x82, 0xA8, 0x82, 0xE2, 0x82, 0xDC];
  string s2 = s1.fromSJIS.toJIS;
  s2.writeHex;
  
  auto fi = File("sjis.txt", "rt");
  scope(exit) fi.close();
  auto fo = File("jis.txt", "wt");
  scope(exit) fo.close();
  string line;
  while ( (line = fi.readln()) !is null ){
    fo.write(line.fromSJIS.toJIS);
  }
}
