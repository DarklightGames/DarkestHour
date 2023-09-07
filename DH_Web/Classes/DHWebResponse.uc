//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHWebResponse extends WebResponse;

enum EHTTPErrorCode
{
    HTTP_400,
    HTTP_401,
    HTTP_403,
    HTTP_404,
    HTTP_405,
    HTTP_500,
    HTTP_501,
    HTTP_503
};

enum EErrorContentType
{
    TYPE_None,
    TYPE_HTML,
    TYPE_JSON
};

var string DefaultContentType; // Content-Type used when it's not explicitly set
var bool   bHasBody;           // the request has body, include Content-Type header

event SendText(string Text, optional bool bNoCRLF)
{
    bHasBody = true;

    if (!bSentText)
    {
        SendStandardHeaders();
        bSentText = true;
    }

    if (bNoCRLF)
    {
        Connection.SendText(Text);
    }
    else
    {
        Connection.SendText(Text$Chr(13)$Chr(10));
    }
}

function SendCachedFile(string Filename, optional string ContentType)
{
    bHasBody = true;

    if (!bSentText)
    {
        SendStandardHeaders(ContentType, true);
    }

    IncludeUHTM(Filename);
}

// Send HTTP error headers and a body
// Replaces deprecated HTTPError fnction
function SendHTTPError(EHTTPErrorCode Code,
                       EErrorContentType CT,
                       optional string Data)
{
    switch (Code)
    {
        case HTTP_400:
            HTTPResponse("HTTP/1.1 400 Bad Request");
            SendErrorBody(CT, 400, "Bad Request");
            break;

        case HTTP_401:
            HTTPResponse("HTTP/1.1 401 Unauthorized");

            if (Data != "")
            {
                HTTPHeader("WWW-Authenticate: Basic realm=\""$Data$"\"");
            }

            SendErrorBody(CT, 401, "Unauthorized");
            break;

        case HTTP_403:
            HTTPResponse("HTTP/1.1 403 Forbidden");
            SendErrorBody(CT, 403, "Forbidden");
            break;

        case HTTP_404:
            HTTPResponse("HTTP/1.1 404 Not Found");
            SendErrorBody(CT, 404, "Not Found");
            break;

        case HTTP_405:
            // https://httpwg.org/specs/rfc9110.html#status.405
            //
            // The origin server MUST generate an Allow header field in a 405
            // response containing a list of the target resource's currently
            // supported methods.
            //
            // Example:
            // Allow: GET, POST
            HTTPResponse("HTTP/1.1 405 Method Not Allowed");

            if (Data != "")
            {
                HTTPHeader("Allow:" @ Data);
            }
            else
            {
                Warn("'Allow' header must be set for '405 Method Not Allowed'!");
            }

            SendErrorBody(CT, 405, "Method Not Allowed");
            break;

        case HTTP_500:
            HTTPResponse("HTTP/1.1 500 Internal Server Error");
            SendErrorBody(CT, 500, "Internal Server Error");
            break;

        case HTTP_501:
            HTTPResponse("HTTP/1.1 501 Not Implemented");
            SendErrorBody(CT, 501, "Not Implemented");
            break;

        case HTTP_503:
            HTTPResponse("HTTP/1.1 503 Service Unavailable");

            if (Data != "")
            {
                HTTPHeader("Retry-After:" @ Data);
            }

            SendErrorBody(CT, 503, "Service Unavailable");
            break;

        default:
    }
}

protected function SendErrorBody(EErrorContentType ECT, int Code, string Title)
{
    switch (ECT)
    {
        case TYPE_HTML:
            SendText("<!DOCTYPE html><title>"$Code@Title$"</title><h1>"$Code@Title);
            return;

        case TYPE_JSON:
            SendStandardHeaders("application/json");
            SendText("{}");
            return;

        default:
            return;
    }
}

function SendStandardHeaders(optional string ContentType, optional bool bCache)
{
    if (!bSentResponse)
    {
        HTTPResponse("HTTP/1.1 200 OK");
    }

    HTTPHeader("Server: dhserver "$DarkestHourGame(Connection.Level.Game).Version.ToString());

    // Add Content-Type when the response has a body or when type is explicitly
    // defined.
    if (bHasBody || ContentType != "")
    {
        if (ContentType == "")
        {
            ContentType = DefaultContentType;
        }

        HTTPHeader("Content-Type:" @ ContentType $ "; charset=" $ CharSet);
    }

    if (bCache)
    {
        HTTPHeader("Cache-Control: max-age="$Connection.WebServer.ExpirationSeconds);
        HTTPHeader("Expires:" @ GetHTTPExpiration(Connection.WebServer.ExpirationSeconds));
    }

    HTTPHeader("Connection: close");
    HTTPHeader("");

    bSentText = true;
}

function Redirect(string URL)
{
    HTTPResponse("HTTP/1.1 301 Moved Permanently");
    HTTPHeader("Location: "$URL);
    SendStandardHeaders();
}

// Basic authentication failure
function FailAuthentication(string Realm)
{
    SendHTTPError(HTTP_401, TYPE_HTML, Realm);
}

// Deprecated error handling
function HTTPError(int ErrorNum, optional string Data)
{
    Warn("HTTPError is deprecated, use HTTPErrorCode instead.");
}

defaultproperties
{
    DefaultContentType="text/html"
}
