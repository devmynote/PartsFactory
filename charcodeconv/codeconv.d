module charcodeconv;

import std.conv;
import std.stdio;
import std.string;
import std.windows.charset : fromMBSz, toMBSz;
import core.sys.windows.winnls : MultiByteToWideChar, WideCharToMultiByte;

string toSJIS(string s)
{	// UTF8 → SJIS
	return ( s.toMBSz.to!string );
}

string fromSJIS(string s)
{	// SJIS → UTF8
	return ( s.toStringz.fromMBSz );
}

string toCodePage(string s, int codePage)
{	// UTF8 → (codePage)
	char[] ret;
	wstring sw = s.to!wstring;
	int len = WideCharToMultiByte(codePage, 0, sw.ptr, cast(int)sw.length, null, 0, null, null);
	if ( len > 0 ){
		ret.length = len;
		WideCharToMultiByte(codePage, 0, sw.ptr, cast(int)sw.length, ret.ptr, len, null, null);
	}
	return ( ret.to!string );
}

string fromCodePage(string s, int codePage)
{	// (codePage) → UTF8
	wstring ret;
	int len = MultiByteToWideChar(codePage, 0, s.ptr, cast(int)s.length, null, 0);
	if ( len > 0 ){
		ret.length = len;
		MultiByteToWideChar(codePage, 0, s.ptr, cast(int)s.length, cast(wchar*)ret.ptr, len);
	}
	return ( ret.to!string );
}

string toJIS(string s)
{	// UTF8 → JIS(50220)
	return ( s.toMBSz(50220).to!string );
}

string fromJIS(string s)
{	// JIS(50220) → UTF8
	return ( s.fromCodePage(50220) );
}

string toEUC(string s)
{	// UTF8 → EUC(20932)
	return ( s.toMBSz(20932).to!string );
}

string fromEUC(string s)
{	// EUC(20932) → UTF8
	return ( s.toStringz.fromMBSz(20932) );
}

string toEBCDIC(string s)
{	// UTF8 → EBCDIC(20290)
	return ( s.toCodePage(20290) );
}

string fromEBCDIC(string s)
{	// EBCDIC(20290) → UTF8
	return ( s.fromCodePage(20290) );
}

static class CP930TBL {
	static private wstring CP930toUTF8 = import("cp930.txt");
	static private uint[wchar] UTF8toCP930;
	
	static this() {
		UTF8toCP930 = initConvTbl();
	}
	
	static private uint[wchar] initConvTbl()
	{
		uint[wchar] cp930tbl;
		foreach ( hi, line; CP930toUTF8.split("\n") ){
			foreach ( lo, c; line ){
				cp930tbl[c] = cast(uint)((hi << 8) + lo + 0x4040);
			}
		}
		cp930tbl['　'] = 0x4040;
		return ( cp930tbl );
	}
	
	static string to(string s)
	{	// UTF8 → CP930
		char[] ret;
		foreach ( cw ; s.to!wstring ){
			auto c1 = UTF8toCP930[cw];
			ret ~= [cast(char)(c1 >> 8), cast(char)(c1 & 0xff)];
		}
		return ( ret.to!string );
	}
	
	static string from(string s)
	{	// CP930 → UTF8
		wchar[] ret;
		for ( int i = 0; i < s.length ; i += 2 ){
			int hi = s[i  ] - 0x40;
			int lo = s[i+1] - 0x40;
			ret ~= CP930toUTF8[hi * (0xff - 0x3F + 1) + lo];
		}
		return ( ret.to!string );
	}
}
alias toCP930   = CP930TBL.to;
alias fromCP930 = CP930TBL.from;

void writeHex(string s)
{	// 文字列の16進数表示
	foreach ( c ; s ){
		writef("%x ", c);
	}
	writeln();
}
