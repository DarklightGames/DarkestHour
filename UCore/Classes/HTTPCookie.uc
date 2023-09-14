//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// https://tools.ietf.org/html/rfc6265#section-4.1.1
//==============================================================================

class HTTPCookie extends Object;

var string CookieName;
var string Value;
var int Expires;
var int MaxAge;
var string NonZeroDigit;
var string Domain;
var string Path;
var bool bSecure;
var bool bHTTPOnly;
var array<string> Extensions;
