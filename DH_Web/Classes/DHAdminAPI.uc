//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHAdminAPI extends WebApplication;

const APIKEY_MIN_LENGTH = 16;

enum EAPIKeyError
{
    APIKEY_NoError,
    APIKEY_Empty,
    APIKEY_TooShort
};

enum ELogLevel
{
    LOG_Quiet,  // only log occasional status updates
    LOG_Post,   // log POST requests
    LOG_Verbose // might produce spam in production
};

var config string    APIKey;         // must be set and be secure
var config ELogLevel LoggingLevel;   // how detailed you want the logs to be
var config bool      bEnableConsole; // grants full console access via API (use
                                     // with caution)

// Logging helper
function RaiseLog(string Message, optional ELogLevel LogLevel)
{
    if (LogLevel > LoggingLevel)
    {
        return;
    }

    Log("AdminAPI:" @ Message);
}

function bool IsMapChanging()
{
    return Level.NextURL != "";
}

// Send 503 Service Unavailabe and JSON status if server is changing maps
function bool CaughtAndHandledMapChange(DHWebResponse Response)
{
    if (IsMapChanging())
    {
        Response.SendHTTPError(HTTP_503, TYPE_None, "60");
        Response.SendStandardHeaders("application/json");
        Response.SendText("{\"next_map\":\"" $ Level.NextURL $ "\"}");
        RaiseLog("Request cannot be handled during a map switch", LOG_Verbose);

        return true;
    }
}

// Check if API key is valid
function EAPIKeyError GetAPIKeyError()
{
    if (APIKey == "")
    {
        return APIKEY_Empty;
    }
    else if (Len(APIKey) < APIKEY_MIN_LENGTH)
    {
        return APIKEY_TooShort;
    }

    return APIKEY_NoError;
}

function Init()
{
    local bool bAPIKeyIsValid;

    switch (GetAPIKeyError())
    {
        case APIKEY_NoError:
            bAPIKeyIsValid = true;
            break;
        case APIKEY_Empty:
            RaiseLog("API key cannot be empty!");
            break;
        case APIKEY_TooShort:
            RaiseLog("API key is too short. Set it to something secure!");
            break;
        default:
            RaiseLog("API key is invalid!");
    }

    if (!bAPIKeyIsValid)
    {
        WebServer.Destroy();
        return;
    }

    RaiseLog("Started and listening on port" @ WebServer.ListenPort);
}

event Query(WebRequest Request, WebResponse Response)
{
    local DHWebRequest Req;
    local DHWebResponse Resp;

    Req = DHWebRequest(Request);
    Resp = DHWebResponse(Response);

    RaiseLog("Requested URL \"" $
             Req.URI $
             "\" from" @
             Resp.Connection.IpAddrToString(Resp.Connection.RemoteAddr),
             LOG_Verbose);

    // Do not process any requests when API key is not set.
    // The web server is supposed to shut down on Init() if the key is
    // misconfigured, but we check it anyway just to be sure.
    if (GetAPIKeyError() != APIKEY_NoError)
    {
        RaiseLog("Request denied. Server API key is invalid!", LOG_Verbose);
        Resp.SendHTTPError(HTTP_500, TYPE_JSON);
        return;
    }

    // Authenticate
    if (Req.APIKey != APIKey)
    {
        RaiseLog("Unathorized request from", LOG_Verbose);
        Resp.SendHTTPError(HTTP_401, TYPE_JSON);
        return;
    }

    // Check if method is implemented
    if (Req.HTTPMethod == HTTP_NotImplemented)
    {
        Resp.SendHTTPError(HTTP_501, TYPE_JSON);
    }

    // NOTE: Does this work?
    if (CaughtAndHandledMapChange(Resp))
    {
        return;
    }

    // Routes
    switch (Req.URI)
    {
        case "/":
            HandleRoot(Req, Resp);
            break;
        case "/server":
            HandleServer(Req, Resp);
            break;
        case "/game":
            HandleGame(Req, Resp);
            break;
        case "/players":
            HandlePlayers(Req, Resp);
            break;
        case "/console":
            HandleConsole(Req, Resp);
            break;
        default:
            Resp.SendHTTPError(HTTP_404, TYPE_JSON);
            return;
    }
}

// ROOT
// =====================================================================

function HandleRoot(DHWebRequest Request, DHWebResponse Response)
{
    switch (Request.HTTPMethod)
    {
        case HTTP_GET:
        case HTTP_HEAD:
            Response.Redirect(Path $ "/game");
            return;
        default:
            Response.SendHTTPError(HTTP_405, TYPE_JSON, "GET, HEAD");
            return;
    }
}

// SERVER
// =====================================================================

function HandleServer(DHWebRequest Request, DHWebResponse Response)
{
    local DHGameReplicationInfo GRI;
    local JSONObject Payload;

    switch (Request.HTTPMethod)
    {
        case HTTP_GET:
        case HTTP_HEAD:
            GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

            if (GRI == none)
            {
                Response.SendHTTPError(HTTP_500, TYPE_JSON);
                RaiseLog("Request failed, GRI not found.", LOG_Verbose);
                return;
            }

            Payload = (new class'JSONObject')
                      .PutString("server_name", GRI.ServerName)
                      .PutInteger("max_players", GRI.MaxPlayers)
                      .PutInteger("players", GRI.PRIArray.Length)
                      .PutInteger("tick", GRI.ServerTickHealth)
                      .PutInteger("loss", GRI.ServerNetHealth);

            Response.SendStandardHeaders("application/json");
            Response.SendText(Payload.Encode());
            return;

        default:
            Response.SendHTTPError(HTTP_405, TYPE_JSON, "GET, HEAD");
            return;
    }
}

// GAME
// =====================================================================

function HandleGame(DHWebRequest Request, DHWebResponse Response)
{
    local DarkestHourGame DHG;
    local DHGameReplicationInfo GRI;
    local JSONObject Payload;

    switch (Request.HTTPMethod)
    {
        case HTTP_GET:
        case HTTP_HEAD:
            DHG = DarkestHourGame(Level.Game);
            GRI = DHG.GRI;

            if (GRI == none)
            {
                Response.SendHTTPError(HTTP_500, TYPE_JSON);
                RaiseLog("Request failed, GRI not found.", LOG_Verbose);
                return;
            }

            Payload = (new class'JSONObject')
                      .PutString("map", Level.GetURLMap())
                      .PutString("game_type", GRI.GameType.default.GameTypeName)
                      .PutInteger("time_elapsed", GRI.ElapsedTime - GRI.RoundStartTime)
                      .PutInteger("time_left", GRI.RemainingTime)
                      .PutString("axis_spawns", GRI.SpawnsRemaining[0])
                      .PutString("allied_spawns", GRI.SpawnsRemaining[1]);

            Response.SendStandardHeaders("application/json");
            Response.SendText(Payload.Encode());
            return;

        default:
            Response.SendHTTPError(HTTP_405, TYPE_JSON, "GET, HEAD");
            return;
    }
}

// PLAYERS
// =====================================================================

function HandlePlayers(DHWebRequest Request, DHWebResponse Response)
{
    switch (Request.HTTPMethod)
    {
        case HTTP_GET:
            Response.SendStandardHeaders("application/json");
            Response.SendText(SerializePlayers().Encode());
            return;

        case HTTP_HEAD:
            Response.SendStandardHeaders();
            return;

        default:
            Response.SendHTTPError(HTTP_405, TYPE_JSON, "GET, HEAD");
            return;
    }
}

function JSONObject SerializePlayers()
{
    local JSONArray JSONData;
    local DHPlayer PC;
    local Controller C;

    JSONData = class'JSONArray'.static.Create();

    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        PC = DHPlayer(C);

        if (PC == none || PC.PlayerReplicationInfo == none)
        {
            continue;
        }

        JSONData.Add((new class'JSONObject')
                     .PutString("roid", PC.GetPlayerIDHash())
                     .PutString("guid", Caps(class'MD5Hash'.static.GetHashString(PC.ClientGUID)))
                     .PutString("name", PC.PlayerReplicationInfo.PlayerName)
                     .PutString("addr", PC.GetPlayerNetworkAddress()));
    }

    return (new class'JSONObject').Put("players", JSONData);
}

// CONSOLE
// =====================================================================

function HandleConsole(DHWebRequest Request, DHWebResponse Response)
{
    local string Command;

    if (!bEnableConsole)
    {
        Response.SendHTTPError(HTTP_403, TYPE_JSON); // Forbidden
        RaiseLog("Console access is disabled. Refused attemt to execute command \"" @
                 Command $
                 "\"",
                 LOG_Verbose);
        return;
    }

    switch (Request.HTTPMethod)
    {
        case HTTP_POST:
            Command = Request.GetVariable("command");

            if (Level != none)
            {
                Level.ConsoleCommand(Command);

                Response.SendStandardHeaders("application/json");
                Response.SendText("{}");
                RaiseLog("Received console command \"" $ Command $ "\"", LOG_Post);
            }
            else
            {
                Response.SendHTTPError(HTTP_500, TYPE_JSON);
                RaiseLog("Failed to execute console command \"" @ Command $ "\"");
            }

            return;

        default:
            Response.SendHTTPError(HTTP_405, TYPE_JSON, "POST");
            return;
    }
}
