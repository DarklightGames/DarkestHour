//==============================================================================
// Darklight Games (c) 2008-2021
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
var bool Secure;
var bool HTTPOnly;
var array<string> Extensions;
