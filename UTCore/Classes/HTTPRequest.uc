//==============================================================================
// Darklight Games (c) 2008-2015
//==============================================================================

class HTTPRequest extends Actor;

var UTCoreBufferedTCPLink MyLink;
var string Method;
var string Host;
var string Path;
var string Protocol;
var Dictionary Headers;
var private int Timeout;

delegate OnResponse(int Status, Dictionary Headers, string Content);

function PostBeginPlay()
{
    super.PostBeginPlay();

    Headers = new class'Dictionary';

    MyLink = Spawn(class'UTCoreBufferedTCPLink');
    MyLink.ResetBuffer();
}

function Send()
{
    MyLink.ServerIpAddr.Port = 0;
    MyLink.Resolve(Host);

    SetTimer(1, true);
}

function static int ParseStatus(string S)
{
    local array<string> Parts;

    Split(S, " ", Parts);

    if (Parts.Length == 3 && Parts[0] == "HTTP/1.1")
    {
        return int(Parts[1]);
    }

    return -1;
}

function static Dictionary ParseHeaders(string S)
{
    local int i;
    local int j;
    local Dictionary Headers;
    local array<string> Lines;
    local string Key;
    local string Value;

    Headers = new class'Dictionary';

    Split(S, Chr(13) $ Chr(10), Lines);

    for (i = 0; i < Lines.Length; ++i)
    {
        j = InStr(Lines[i], ":");

        Key = Left(Lines[i], j);
        Value = Mid(Lines[i], j + 2);

        Headers.Put(Key, Value);
    }

    return Headers;
}

function Timer()
{
    local string TransferEncoding;
    local string Response;
    local string Command;
    local string Content;
    local string StatusString;
    local string HeadersString;
    local string Value;
    local int Status;
    local Dictionary ResponseHeaders;
    local int i;
    local array<string> HeaderKeys;
    local int ChunkLength;

    if (MyLink.ReceiveState == MyLink.Match)
    {
        if (MyLink.PeekChar() != 0)
        {
            Response = MyLink.InputBuffer;

            Divide(Response, MyLink.CRLF, StatusString, Response);
            Divide(Response, MyLink.CRLF $ MyLink.CRLF, HeadersString, Response);

            Status = ParseStatus(StatusString);
            ResponseHeaders = ParseHeaders(HeadersString);

            if (ResponseHeaders.Get("Transfer-Encoding", TransferEncoding) &&
                TransferEncoding ~= "chunked")
            {
                while (true)
                {
                    // Find index of chunk length terminator
                    i = InStr(Response, MyLink.CRLF);

                    // Parse chunk length
                    ChunkLength = class'UTCore'.static.Hex2Int(Mid(Response, 0, i));

                    if (ChunkLength <= 0)
                    {
                        break;
                    }

                    // Read response chunk into content
                    Content $= Mid(Response, i + 2, ChunkLength);

                    Response = Mid(Response, i + 4 + ChunkLength);
                }
            }
            else
            {
                Content = Response;
            }

            OnResponse(Status, ResponseHeaders, Content);

            MyLink.DestroyLink();

            Destroy();
        }
    }
    else if (MyLink.ReceiveState == "" && MyLink.ServerIpAddr.Port != 0 && MyLink.IsConnected())
    {
        Command = Method @ Path @ Protocol $ MyLink.CRLF $
            "Host:" @ Host $ MyLink.CRLF;

        HeaderKeys = Headers.GetKeys();

        for (i = 0; i < HeaderKeys.Length; ++i)
        {
            Headers.Get(HeaderKeys[i], Value);

            Command $= HeaderKeys[i] $ ":" @ Value $ MyLink.CRLF;
        }

        Command $= MyLink.CRLF;

        MyLink.SendCommand(Command);
        MyLink.WaitForCount(0, Timeout, 0);
    }
    else if (MyLink.ReceiveState == MyLink.Timeout)
    {
        OnResponse(408, none, "");
    }

    Timeout -= 1;
}

function int GetTimeout()
{
    return Timeout;
}

defaultproperties
{
    Method="GET"
    Timeout=30
    Protocol="HTTP/1.1"
}
