//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// https://github.com/php/php-src/blob/c72282a13b12b7e572469eba7a7ce593d900a8a2/ext/standard/url.c
//==============================================================================

class URL extends Object;

var string Scheme;
var string Username;
var string Password;
var string Host;
var string Path;
var string Query;
var string Fragment;
var int Port;

const TOKEN_PATH = "/";
const TOKEN_HASH = "#";
const TOKEN_QUERY = "?";
const TOKEN_PROTOCOL = "://";
const TOKEN_USER = "@";
const TOKEN_USERPASS = ":";
const TOKEN_PORT = ":";

const URL_ESCAPE = "%";

/**
    Encode special characters, you should not use this function, it's slow and not
    secure, so try to avoid it.
    ";", "/", "?", ":", "@", "&", "=", "+", ",", "$" and " "
*/
final static function string RawUrlEncode(string S)
{
    ReplaceText(S, ";", "%3B");
    ReplaceText(S, "/", "%2F");
    ReplaceText(S, "?", "%3F");
    ReplaceText(S, ":", "%3A");
    ReplaceText(S, "@", "%40");
    ReplaceText(S, "&", "%26");
    ReplaceText(S, "=", "%3D");
    ReplaceText(S, "+", "%2B");
    ReplaceText(S, ",", "%2C");
    ReplaceText(S, "$", "%24");
    ReplaceText(S, " ", "%20");

    return S;
}

/**
    This will decode URL encoded elements. If bIgnorePlus is set to true '+' will
    not be changed to a space
*/
final static function string RawUrlDecode(string S, optional bool bIgnorePlus)
{
    local int i;
    local string Char;

    if (!bIgnorePlus)
    {
        ReplaceText(S, "+", " ");
    }

    i = InStr(S, URL_ESCAPE);

    while (i >= 0)
    {
        Char = Mid(S, i + 1, 2);
        Char = Chr(class'UInteger'.static.FromHex(Char));

        if (Char == "%")
        {
            Char = Chr(1);
        }

        S = Left(S, i) $ Char $ Mid(S, i + 3);
        i = InStr(S, URL_ESCAPE);
    }

    ReplaceText(S, Chr(1), URL_ESCAPE); // % was replace with \1

    return S;
}

final static function int GetPortByProtocol(string Protocol)
{
    switch (Protocol)
    {
        case "http":
            return 80;
        case "https":
            return 443;
    }

    return 0;
}

final static function URL FromString(string S)
{
    local URL URL;
    local int i, j;

    URL = new class'URL';

    i = InStr(S, TOKEN_PROTOCOL);

    if (i <= 0)
    {
        return none;
    }

    URL.Scheme = Left(S, i);
    S = Mid(S, i + Len(TOKEN_PROTOCOL));
    i = InStr(S, TOKEN_USER);

    if (i == -1)
    {
        URL.Username = "";
        URL.Password = "";
    }
    else
    {
        URL.Username = Left(S, i);
        S = Mid(S, i + Len(TOKEN_USER));
        i = InStr(URL.Username, TOKEN_USERPASS);

        if (i == -1)
        {
            URL.Password = "";
        }
        else
        {
            URL.Password = Mid(URL.Username, i + Len(TOKEN_USERPASS));
            URL.Username = Left(URL.Username, i);
        }

        URL.Username = RawUrlDecode(URL.Username);
        URL.Password = RawUrlDecode(URL.Password);
    }

    if (S == "")
    {
        return none;
    }

    i = InStr(S, TOKEN_PATH);

    if (i == -1) // just protocol://hostname
    {
        URL.Host = S;
        URL.Fragment = "";
        URL.Query = "";
        URL.Path = TOKEN_PATH;
        return URL;
    }

    if (i == 0)
    {
        return none; // e.g. http:///, also traps file:/// but we don't give a crap about that
    }

    URL.Host = Left(S, i);

    S = Mid(S, i); // now it contains Location(\?query)?(#fragment)?
    i = InStr(URL.Host, TOKEN_PORT);

    if (i == 0)
    {
        return none; // http://:80/ !?
    }

    URL.Port = -1;

    if (i > 0)
    {
        j = int(Mid(URL.Host, i + 1));

        if (URL.Port == 0) // invalid port no
        {
            return none;
        }
        else if (j != GetPortByProtocol(URL.Scheme))
        {
            URL.Port = j;
        }

        URL.Host = Left(URL.Host, i);
    }

    i = InStr(S, TOKEN_HASH);

    if (i != -1)
    {
        URL.Fragment = Mid(S, i + Len(TOKEN_HASH));
        S = left(S, i);
    }
    else
    {
        URL.Fragment = "";
    }

    i = InStr(S, TOKEN_QUERY);

    if (i != -1)
    {
        URL.Query = Mid(S, i+Len(TOKEN_QUERY));
        S = left(S, i);
    }
    else
    {
        URL.Query = "";
    }

    URL.Path = S;

    return URL;
}
