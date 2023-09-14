//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class HTTPRequest extends Actor;

var HTTPSession Session;
var UCoreBufferedTCPLink MyLink;
var string Method;
var string Host;
var string Path;
var string Protocol;
var bool bAllowRedirects;
var TreeMap_string_string Headers;
var private int Timeout;
var Object UserObject;
var string UserString;

delegate bool OnRedirect(HTTPRequest Request, int Status, string Location);
delegate OnResponse(HTTPRequest Request, int Status, TreeMap_string_string Headers, string Content);

function PostBeginPlay()
{
    super.PostBeginPlay();

    Headers = new class'TreeMap_string_string';

    MyLink = Spawn(class'UCoreBufferedTCPLink');
    MyLink.ResetBuffer();
}

function Send()
{
    MyLink.ServerIpAddr.Port = 0;
    MyLink.Resolve(Host);

    SetTimer(1.0, true);
}

function static int ParseStatus(string S)
{
    local string Version;
    local string StatusCode;
    local string ReasonPhrase;

    Divide(S, " ", Version, S);

    if (Version == "HTTP/1.0" || Version == "HTTP/1.1")
    {
        Divide(S, " ", StatusCode, ReasonPhrase);

        return int(StatusCode);
    }

    return -1;
}

function static TreeMap_string_string ParseHeaders(string S)
{
    local int i;
    local int j;
    local TreeMap_string_string Headers;
    local array<string> Lines;
    local string Key;
    local string Value;

    Headers = new class'TreeMap_string_string';

    Split(S, class'UString'.static.CRLF(), Lines);

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
    local string TransferEncoding, SetCookie;
    local string Response;
    local string Command;
    local string Content;
    local string StatusString;
    local string HeadersString;
    local string Value;
    local string Loc;
    local int Status;
    local TreeMap_string_string ResponseHeaders;
    local int i;
    local array<string> HeaderKeys;
    local int ChunkLength;
    local URL U;
    local HTTPRequest R;
    local Object O;

    if (MyLink.ReceiveState == MyLink.Match)
    {
        if (MyLink.PeekChar() != 0)
        {
            Response = MyLink.InputBuffer;

            Divide(Response, MyLink.CRLF, StatusString, Response);
            Divide(Response, MyLink.CRLF $ MyLink.CRLF, HeadersString, Response);

            Status = ParseStatus(StatusString);

            ResponseHeaders = ParseHeaders(HeadersString);

            // TODO: Fix ParseHeaders to return a TreeMap_string_array_string
            // so we can retrieve multiple instances of Set-Cookie. (this is
            // essentially an "unordered multimap")
            if (ResponseHeaders.Get("Set-Cookie", SetCookie))
            {
                Session.SetCookie(SetCookie);
            }

            switch (Status)
            {
                case 301:   // Moved Permanently
                case 302:   // Found
                case 307:   // Temporary Redirect
                case 308:   // Permanent Redirect
                    if (bAllowRedirects && ResponseHeaders.Get("Location", Loc) && !OnRedirect(self, Status, Loc))
                    {
                        U = class'URL'.static.FromString(Loc);

                        if (U != none)
                        {
                            R = Spawn(class'HTTPRequest');
                            R.Method = self.Method;
                            R.Host = U.Host;
                            R.Path = U.Path;
                            R.Protocol = U.Scheme;
                            R.bAllowRedirects = self.bAllowRedirects;
                            R.Headers = self.Headers;
                            R.Send();
                        }
                        else
                        {
                            Warn("Could not parse URL for redirection (" $ Loc $ ")");
                        }
                    }
                    Destroy();
                    return;
                default:
                    break;
            }

            if (ResponseHeaders.Get("Transfer-Encoding", TransferEncoding) &&
                TransferEncoding ~= "chunked")
            {
                while (true)
                {
                    // Find index of chunk length terminator
                    i = InStr(Response, MyLink.CRLF);

                    // Parse chunk length
                    ChunkLength = class'UInteger'.static.FromHex(Mid(Response, 0, i));

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

            OnResponse(self, Status, ResponseHeaders, Content);

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

        if (Session != none)
        {
            HeaderKeys = Session.Cookies.GetKeys();

            for (i = 0; i < HeaderKeys.Length; ++i)
            {
                Session.Cookies.Get(HeaderKeys[i], O);

                Command $= HeaderKeys[i] $ ":" @ HTTPCookie(O).Value $ MyLink.CRLF;
            }
        }

        // TODO: Add Cookies to the headers

        MyLink.SendCommand(Command);
        MyLink.WaitForCount(0, Timeout, 0);
    }
    else if (MyLink.ReceiveState == MyLink.Timeout)
    {
        OnResponse(self, 408, none, "");
    }

    --Timeout;

    if (Timeout < 0)
    {
        Log("HTTP Request timed out");
        Destroy();
        return;
    }
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
    bHidden=true
}
