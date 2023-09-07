//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHWebRequest extends WebRequest;

enum EHTTPMethod
{
    HTTP_NotImplemented,
    HTTP_GET,
    HTTP_HEAD,
    HTTP_POST,
};

var EHTTPMethod HTTPMethod;
var string APIKey;
var string Host;

function string GetURIType(int MaxTypeLength)
{
    local string Tail;

    Tail = Right(URI, MaxTypeLength);

    return Mid(Tail, InStr(Tail, "."));
}

function ProcessHeaderString(string S)
{
    local int i;

    if (Left(S, 21) ~= "Authorization: Basic ")
    {
        S = DecodeBase64(Mid(S, 21, 256));
        i = InStr(S, ":");

        if (i != -1)
        {
            Username = Left(S, i);
            Password = Mid(S, i+1);
        }
    }
    else if (Left(S, 8) ~= "apikey: ")
    {
        APIKey = Mid(S, 8, 256);
    }
    else if (Left(S, 16) ~= "Content-Length: ")
    {
        ContentLength = Int(Mid(S, 16, 64));
    }
    else if (Left(S, 14) ~= "Content-Type: ")
    {
        ContentType = Mid(S, 14, 512);
    }
    else if (Left(S, 6) ~= "Host: ")
    {
        Host = Mid(S, 14, 512);
    }
}
