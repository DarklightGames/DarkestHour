//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHWebConnection extends WebConnection;

function ReceivedLine(string S)
{
    if (S == "")
    {
        EndOfHeaders();
    }
    else
    {
        if (Left(S, 4) ~= "GET ")       ProcessGet(S);
        else if (Left(S, 5) ~= "POST ") ProcessPost(S);
        else if (Left(S, 5) ~= "HEAD ") ProcessHead(S);
        else if (Request != None)       Request.ProcessHeaderString(S);
    }
}

function ProcessHead(string S)
{
    local DHWebRequest Req;

    ProcessGet(S);

    if (Request == none)
    {
        CreateResponseObject();
    }

    Req = DHWebRequest(Request);
    Req.HTTPMethod = HTTP_HEAD;
}

function ProcessGet(string S)
{
    local DHWebRequest Req;
    local int i;

    if (Request == none)
    {
        CreateResponseObject();
    }

    Req = DHWebRequest(Request);

    Req.RequestType = Request_GET; // Legacy
    Req.HTTPMethod = HTTP_GET;

    S = Mid(S, 4);

    while (Left(S, 1) == " ")
    {
        S = Mid(S, 1);
    }

    i = InStr(S, " ");

    if (i != -1)
    {
        S = Left(S, i);
    }

    i = InStr(S, "?");

    if (i != -1)
    {
        Req.DecodeFormData(Mid(S, i+1));
        S = Left(S, i);
    }

    Application = WebServer.GetApplication(S, Req.URI);

    if (Application != none && Req.URI == "")
    {
        Response.Redirect(S$"/");
        Cleanup();
    }
    else if (Application == none && Webserver.DefaultApplication != -1)
    {
        Response.Redirect(Webserver.ApplicationPaths[Webserver.DefaultApplication]$"/");
        Cleanup();
    }
}

function ProcessPost(string S)
{
    local DHWebRequest Req;
    local int i;

    if (Request == none)
    {
        CreateResponseObject();
    }

    Req = DHWebRequest(Request);

    Req.RequestType = Request_POST; // Legacy
    Req.HTTPMethod = HTTP_POST;

    S = Mid(S, 5);

    while(Left(S, 1) == " ")
    {
        S = Mid(S, 1);
    }

    i = InStr(S, " ");

    if (i != -1)
    {
        S = Left(S, i);
    }

    i = InStr(S, "?");

    if (i != -1)
    {
        Req.DecodeFormData(Mid(S, i+1));
        S = Left(S, i);
    }

    Application = WebServer.GetApplication(S, Req.URI);

    if (Application != none && Req.URI == "")
    {
        Response.Redirect(S$"/");
        Cleanup();
    }
}

function CreateResponseObject()
{
    Request = new(none) class'DHWebRequest';

    Response = new(none) class'DHWebResponse';
    Response.Connection = self;
}
