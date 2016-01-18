//==============================================================================
// Darklight Games (c) 2008-2015
//==============================================================================

class JSONDecoder extends Object
    abstract;

//var private string Current;
//var private int BufferOffset;
//var private int Index;
//var private int Fill;
//var private int Line;
//var private int LineOffset;
//var private StringBuffer CaptureBuffer;
//var private int CaptureStart;
//
//function JSONValue Decode(string S)
//{
//    local JSONValue Result;
//
//    Read();
//    SkipWhitespace();
//
//    Result = ReadValue();
//
//    SkipWhitespace();
//
//    if (!IsEndOfText())
//    {
//        ErrorOut("Unexpected character");
//
//        return none;
//    }
//
//    return Result;
//}
//
//private function JSONValue ReadValue()
//{
//    switch (Current)
//    {
//        case "n":
//            return ReadNull();
//        case "t":
//            return ReadTrue();
//        case "f":
//            return ReadFalse();
//        case "\"":
//            return ReadString();
//        case "[":
//            return ReadArray();
//        case "{":
//            return ReadObject();
//        case "-":
//        case "0":
//        case "1":
//        case "2":
//        case "3":
//        case "4":
//        case "5":
//        case "6":
//        case "7":
//        case "8":
//        case "9":
//            return ReadNumber();
//        default:
//            ErrorOut("value");
//    }
//}
//
//private function JSONArray ReadArray()
//{
//    local JSONArray Array_;
//
//    Read();
//
//    Array = new class'JSONArray';
//
//    SkipWhitespace();
//
//    if (ReadChar("]"))
//    {
//        return Array;
//    }
//
//    do
//    {
//        SkipWhitespace();
//
//        Array_.Values.Add(ReadValue());
//
//        SkipWhitespace();
//    }
//    while (ReadChar(","));
//
//    if (!ReadChar("]"))
//    {
//        ErrorOut("Expected ',' or ']'");
//
//        return none;
//    }
//
//    return Array_;
//}
//
//private function JSONObject ReadObject()
//{
//    local string Key;
//    local JSONObject Object;
//
//    Read();
//
//    Object = new class'JSONObject';
//
//    SkipWhitespace();
//
//    if (Readchar("}"))
//    {
//        return Object;
//    }
//
//    do
//    {
//        SkipWhitespace();
//
//        Key = ReadName();
//
//        SkipWhitespace();
//
//        if (!Readchar(":"))
//        {
//            ErrorOut("Expected ':'");
//        }
//
//        SkipWhitespace();
//
//        Object.Put(Key, ReadValue());
//
//        SkipWhitespace();
//    }
//    while (ReadChar(","));
//
//    if (!ReadChar("}"))
//    {
//        ErrorOut("Expected ',' or '}'");
//    }
//
//    return Object;
//}
//
//private function string ReadName()
//{
//    if (Current != "\"")
//    {
//        ErrorOut("Expected name");
//    }
//
//    return ReadStringInternal();
//}
//
//private function JSONValue ReadNull()
//{
//    Read();
//    ReadRequiredChar("u");
//    ReadRequiredChar("l");
//    ReadRequiredChar("l");
//
//    return class'JSONLiteral'.static.Create("null");
//}
//
//private function JSONValue ReadTrue()
//{
//    Read();
//    ReadRequiredChar("r");
//    ReadRequiredChar("u");
//    ReadRequiredChar("e");
//
//    return class'JSONLiteral'.static.Create("true");
//}
//
//private function JSONValue ReadFalse()
//{
//    Read();
//    ReadRequiredChar("a");
//    ReadRequiredChar("l");
//    ReadRequiredChar("s");
//    ReadRequiredChar("e");
//
//    return class'JSONLiteral'.static.Create("false");
//}
//
//private function JSONValue ReadString()
//{
//    return class'JSONString'.static.Ceate(ReadStringInternal());
//}
//
//private function string ReadStringInternal()
//{
//    local string String;
//
//    Read();
//
//    StartCapture();
//
//    while (Current != "\"")
//    {
//        if (Current == "\\")
//        {
//            PauseCapture();
//            ReadEscape();
//            StartCapture();
//        }
//        else if (Current < 0x20)
//        {
//            ErrorOut("Expected valid string character");
//        }
//        else
//        {
//            Read();
//        }
//    }
//
//    String = EndCapture();
//
//    Read();
//
//    return String;
//}
//
//private function ReadEscape()
//{
//    local string HexChars;
//
//    Read();
//
//    switch (Current)
//    {
//        case "\"":
//        case "/":
//        case "\\":
//            CaptureBuffer.Append(Current);
//            break;
//            //TODO: all of these need to be done with 0x00 codes
//        case "b":
//            CaptureBuffer.Append("\b");
//            break;
//        case "f":
//            CaptureBuffer.Append("\f");
//            break;
//        case "n":
//            CaptureBuffer.Append("\n");
//            break;
//        case "r":
//            CaptureBuffer.Append("\r");
//            break;
//        case "t":
//            CaptureBuffer.Append("\t");
//            break;
//        case "u":
//            for (i = 0; i < 4; ++i)
//            {
//                Read();
//
//                if (!IsHexDigit())
//                {
//                    ErrorOut("Expected hexadecimal digit");
//                }
//
//                HexChars $= Current;
//            }
//
//            CaptureBuffer.Append(Chr(class'UCore'.static.Hex2Int(HexChars)));
//            break;
//        default:
//            ErrorOut("Expected valid escape sequence");
//    }
//
//    Read();
//}
//
//private function JSONValue ReadNumber()
//{
//    local int FirstDigit;
//
//    StartCapture();
//
//    ReadChar("-");
//
//    FirstDigit = int(Current);
//
//    if (!ReadDigit())
//    {
//        ErrorOut("Expected digit");
//    }
//
//    if (FirstDigit != 0)
//    {
//        while (ReadDigit())
//        {
//        }
//    }
//
//    ReadFraction();
//    ReadExponent();
//
//    return class'JSONNumber'.static.Create(EndCapture());
//}
//
//private function bool ReadFraction()
//{
//    if (!ReadChar("."))
//    {
//        return false;
//    }
//
//    if (!ReadDigit())
//    {
//        ErrorOut("Expected digit");
//    }
//
//    while (ReadDigit())
//    {
//    }
//
//    return true;
//}
//
//private function bool ReadExponent()
//{
//    if (!ReadChar("e") && !ReadChar("E"))
//    {
//        return false;
//    }
//
//    if (!ReadChar("+"))
//    {
//        ReadChar("-");
//    }
//
//    if (!ReadDigit())
//    {
//        ErrorOut("Expected digit");
//    }
//
//    while (ReadDigit())
//    {
//    }
//
//    return true;
//}
//
//private function bool ReadChar(string S)
//{
//    if (Current != S)
//    {
//        return false;
//    }
//
//    Read();
//
//    return true;
//}
//
//private function bool ReadDigit()
//{
//    if (!IsDigit())
//    {
//        return false;
//    }
//
//    Read();
//
//    return true;
//}
//
//private function SkipWhitespace()
//{
//    while (IsWhitespace())
//    {
//        Read();
//    }
//}
//
//private function Read()
//{
//    if (Index == Fill)
//    {
//        if (CaptureStart != -1)
//        {
//            CaptureBuffer.Append(Buffer, CaptureStart, Fill - CaptureStart);
//
//            CaptureStart = 0;
//        }
//    }
//
//    BufferOffset += Fill;
//
//    Fill = Read.Read(Buffer, 0, Buffer.Length);
//
//    Index = 0;
//
//    if (Fill == -1)
//    {
//        Current = -1;
//
//        return;
//    }
//
//    if (Current == 0x0A) // \n
//    {
//        ++Line;
//
//        LineOFfset = BufferOffset + Index;
//    }
//
//    Current = Mid(Buffer, Index++, 1);
//}
//
//private function StartCapture()
//{
//    if (CaptureBuffer == null)
//    {
//        CaptureBuffer = new class'StringBuffer';
//    }
//
//    CaptureStart = Index - 1;
//}
//
//private function PauseCapture()
//{
//    local int End;
//
//    if (Current == -1)
//    {
//        End = Index;
//    }
//    else
//    {
//        End = Index - 1;
//    }
//
//    CaptureBuffer.Append(Buffer, CaptureStart, End - CaptureStart);
//
//    CaptureStart = -1;
//}
//
//private function string EndCapture()
//{
//    local int End;
//    local string Captured;
//
//    if (Current == -1)
//    {
//        End = Index;
//    }
//    else
//    {
//        End = Index - 1;
//    }
//
//    if (CaptureBuffer.Length() > 0)
//    {
//        CaptureBuffer.Append(Buffer, CaptureStart, End - CaptureStart);
//        Captured = CaptureBuffer.ToString();
//        CaptureBuffer.SetLength(0);
//    }
//    else
//    {
//        Captured = Mid(Buffer, CaptureStart, End - CaptureStart);
//    }
//
//    CaptureStart = -1;
//
//    return Captured;
//}
//
//private function bool IsWhitespace()
//{
//    //TODO: convert to Asc and compare that way
//    return Current == " " || Current == "\t" || Current == "\n" || Current == "\r";
//}
//
//private function bool IsDigit()
//{
//    return Asc(Current) >= 0x30  && Asc(Current) <= 0x39;
//}
//
//private function bool IsHexDigit()
//{
//    return Asc(Current) >= 0x30 && Asc(Current) <= 0x39
//        || Asc(Current) >= 0x61 && Asc(Current) <= 0x66
//        || Asc(Current) >= 0x41 && Asc(Current) <= 0x46;
//}
//
//private function bool IsEndOfText()
//{
//    return Current == -1;
//}
//
//private function ErrorOut(string Message)
//{
//    local int AbsIndex;
//    local int Column;
//    local int Offset;
//
//    AbsIndex = BufferOffset + Index;
//    Column = AbsIndex - LineOffset;
//
//    if (IsEndOfText())
//    {
//        Offset = AbsIndex;
//    }
//    else
//    {
//        Offset = AbsIndex - 1;
//    }
//
//    Warn(Message @ "(Offset:" @ string(Offset) $ ", Line:" @ string(Line) $ ", Column:" @ string(Column - 1) $ ")");
//}
