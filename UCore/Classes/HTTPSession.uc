//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// https://tools.ietf.org/html/rfc626
//==============================================================================

class HTTPSession extends Object;

var TreeMap_string_Object Cookies;

function HTTPCookie SetCookie(string S)
{
    local int i;
    local array<string> Crumbs;
    local string CookieName, AttributeName;
    local string Value;
    local HTTPCookie Cookie;
    local Object O;

    Split(S, ";", Crumbs);

    if (Crumbs.Length <= 0)
    {
        Warn("Invalid Set-Cookie value:" @ S);
        return none;
    }

    Divide(Crumbs[0], "=", CookieName, Value);

    Value = class'UString'.static.Trim(Value);

    // Check for existing cookie.
    if (Cookies.Get(CookieName, O))
    {
        Cookie = HTTPCookie(O);
    }
    else
    {
        Cookie = new class'HTTPCookie';
        Cookie.CookieName = CookieName;
    }

    Cookie.Value = Value;

    for (i = 1; i < Crumbs.Length; ++i)
    {
        Divide(Crumbs[i], "=", AttributeName, Value);

        Value = class'UString'.static.Trim(Value);

        if (AttributeName ~= "Expires")
        {
            Cookie.Expires = int(Value);
        }
        else if (AttributeName ~= "Max-Age")
        {
            Cookie.MaxAge = int(Value);
        }
        else if (AttributeName ~= "Domain")
        {
            Cookie.Domain = Value;
        }
        else if (AttributeName ~= "Path")
        {
            Cookie.Path = Value;
        }
        else if (AttributeName ~= "Secure")
        {
            Cookie.bSecure = true;
        }
        else if (AttributeName ~= "HttpOnly")
        {
            Cookie.bHTTPOnly = true;
        }
        else
        {
            Cookie.Extensions[Cookie.Extensions.Length] = Value;
        }
    }
}

