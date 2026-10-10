//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWebQueryDefaults extends xWebQueryDefaults
    config;

enum EOperationError
{
    ERR_OK,                  // 200
    ERR_BadRequest,          // 400
    ERR_Conflict,            // 409
    ERR_UnprocessableEntity, // 422
};

var config    string DefaultsRestrictionsPage;
var localized string DefaultsRestrictionsLink;
var localized string NoteRestrictionsPage;

function bool Query(WebRequest Request, WebResponse Response)
{
    if (!CanPerform(NeededPrivs))
    {
        return false;
    }

    MapTitle(Response);

    switch (Mid(Request.URI, 1))
    {
        case DefaultPage:                   QueryDefaults(Request, Response);     return true; // Done : General
        case DefaultsIndexPage:             QueryDefaultsMenu(Request, Response); return true; // Done : General
        case DefaultsMapsPage:              if (!MapIsChanging()) QueryDefaultsMaps(Request, Response);         return true;
        case DefaultsRulesPage:             if (!MapIsChanging()) QueryDefaultsRules(Request, Response);        return true;
        case DefaultsRestrictionsPage:      if (!MapIsChanging()) QueryDefaultsRestrictions(Request, Response); return true;
        case DefaultsIPPolicyPage:          if (!MapIsChanging()) QueryDefaultsIPPolicy(Request, Response);     return true;
        case DefaultsRestartPage:           if (!MapIsChanging()) QueryRestartPage(Request, Response);          return true;
        case DefaultsVotingGameConfigPage:  if (!MapIsChanging()) QueryVotingGameConfig(Request, Response);     return true;
    }

    return false;
}

function QueryDefaultsMenu(WebRequest Request, WebResponse Response)
{
    local string	GameType, Page, TempStr, Content;
    local int i;

    GameType = SetGamePI(Request.GetVariable("GameType", string(Level.Game.Class)));
    Page = Request.GetVariable("Page");

    // Set currently active page
    if (CanPerform("Mt"))
    {
        if (Request.GetVariable("GameTypeSet", "") != "")
        {
            TempStr = Request.GetVariable("GameTypeSelect", GameType);

            if (!(TempStr ~= GameType))
            {
                GameType = TempStr;
            }
        }

        Response.Subst("GameTypeButton", SubmitButton("GameTypeSet", Update));
        Response.Subst("GameTypeSelect", Select("GameType", GenerateGameTypeOptions(GameType)));
    }
    else
    {
        Response.Subst("GameTypeSelect", Level.Game.Default.GameName);
    }

    // Set background colors
    Response.Subst("DefaultBG", DefaultBG);	// for unused tabs

    // Set URIs
    Content = MakeMenuRow(Response, GameType $ "&Page=" $ DefaultsMapsPage, DefaultsMapsLink);

    for (i = 0; i < GamePI.Groups.Length; i++)
    {
        Content = Content $ MakeMenuRow(Response, GameType $ "&Page=" $ DefaultsRulesPage $ "&Filter=" $ GamePI.Groups[i], GamePI.Groups[i]);
    }

    Content $= MakeMenuRow(Response, GameType $ "&Page=" $ DefaultsRestrictionsPage, DefaultsRestrictionsLink);
    Content $= MakeMenuRow(Response, GameType $ "&Page=" $ DefaultsIPPolicyPage, DefaultsIPPolicyLink);
    Content $= MakeMenuRow(Response, GameType $ "&Page=" $ DefaultsVotingGameConfigPage, DefaultsVotingGameConfigLink);
    Content $= "<br>" $ MakeMenuRow(Response, GameType $ "&Page=" $ DefaultsRestartPage, DefaultsRestartLink);

    Response.Subst("Content", Content);
    Response.Subst("Filter", Request.GetVariable("Filter", ""));
    Response.Subst("Page", Page);
    Response.Subst("PostAction", DefaultPage);
    ShowPage(Response, DefaultsIndexPage);
}

function EOperationError UpdateRestriction(WebRequest Request)
{
    local DHAccessControl DHAC;
    local int i, j;
    local string PlayerID;

    DHAC = DHAccessControl(Level.Game.AccessControl);
    i = int(Request.GetVariable("IDNo", "-1"));
    PlayerID = Request.GetVariable("PlayerID", "");

    if (i < 0) // CREATE ENTRY
    {
        for (j = 0; j < DHAC.Restrictions.Length; j++)
        {
            if (DHAC.Restrictions[j].PlayerID == PlayerID)
            {
                // Refuse duplicate IDs
                return ERR_Conflict;
            }
        }

        i = DHAC.Restrictions.Length;
        DHAC.Restrictions.Insert(DHAC.Restrictions.Length, 1);
        DHAC.Restrictions[i].PlayerID = PlayerID;
    }
    else if (i >= DHAC.Restrictions.Length || DHAC.Restrictions[i].PlayerID != PlayerID) // UPDATE ENTRY FAILURES
    {
        // Possibly caused by another user modifying the table.
        return ERR_Conflict;
    }

    DHAC.Restrictions[i].bOutboundMessages = Request.GetVariable("OutMsg") != "";
    DHAC.Restrictions[i].bOutboundVoice = Request.GetVariable("OutVoice") != "";
    DHAC.Restrictions[i].bVehicleAccess = Request.GetVariable("VehAccess") != "";
    DHAC.Restrictions[i].bSquadNames = Request.GetVariable("SquadName") != "";
    DHAC.Restrictions[i].ForcedName = Request.GetVariable("ForcedName", "");
    DHAC.ApplyRestrictionsByID(PlayerID);
    DHAC.SaveConfig();
}

function EOperationError DeleteRestriction(WebRequest Request)
{
    local DHAccessControl DHAC;
    local int i;
    local string PlayerID;

    DHAC = DHAccessControl(Level.Game.AccessControl);
    i = int(Request.GetVariable("IDNo", "-1"));
    PlayerID = Request.GetVariable("PlayerID", "");

    if (i < 0 || i >= DHAC.Restrictions.Length || DHAC.Restrictions[i].PlayerID != PlayerID)
    {
        // Possibly caused by another user modifying the table.
        return ERR_Conflict;
    }

    DHAC.Restrictions.Remove(i, 1);
    DHAC.ApplyRestrictionsByID(PlayerID);
    DHAC.SaveConfig();
}

function QueryDefaultsRestrictions(WebRequest Request, WebResponse Response)
{
    local DHAccessControl DHAC;
    local int i;
    local string PlayerID, ItemList;
    local EOperationError OpError;

    // TODO: Requires "Access Policies" permission. Add a granular permission for this in the future.
    if (!CanPerform("Xi"))
    {
        AccessDenied(Response);
        return;
    }

    DHAC = DHAccessControl(Level.Game.AccessControl);

    if (DHAC == none)
    {
        Log("[WebAdmin] QueryDefaultsRestrictions failed: AccessControl is none");
        Response.HTTPResponse("HTTP/1.1 500 Internal Server Error");
        return;
    }

    Response.Subst("Section", DefaultsRestrictionsLink);

    if (Request.GetVariable("Update") != "")
    {
        OpError = UpdateRestriction(Request);
    }

    if (Request.GetVariable("Delete") != "")
    {
        OpError = DeleteRestriction(Request);
    }

    // TODO: Add error bubbles to UI
    // TODO: Extend HTTPError() function with more status codes so I don't have to hardcode them here.
    switch (OpError)
    {
        case ERR_OK:
            break;
        case ERR_Conflict:
            Response.HTTPResponse("HTTP/1.1 409 Conflict");
            break;
        default:
            Response.HTTPResponse("HTTP/1.1 400 Bad Request");
    }

    ItemList = "";

    for (i = 0; i < DHAC.Restrictions.Length; i++)
    {
        PlayerID = DHAC.Restrictions[i].PlayerID;

        Response.Subst("PlayerID", PlayerID);
        Response.Subst("ForcedNameVal", DHAC.Restrictions[i].ForcedName);
        Response.Subst("ForcedName", WebInclude(DefaultsRestrictionsPage $ "_playername"));
        Response.Subst("OutMsg", Checkbox("OutMsg", DHAC.Restrictions[i].bOutboundMessages));
        Response.Subst("OutVoice", Checkbox("OutVoice", DHAC.Restrictions[i].bOutboundVoice));
        Response.Subst("VehAccess", Checkbox("VehAccess", DHAC.Restrictions[i].bVehicleAccess));
        Response.Subst("SquadName", Checkbox("SquadName", DHAC.Restrictions[i].bSquadNames));
        Response.Subst("PostAction", DefaultsRestrictionsPage $ "?IDNo="$string(i));
        Response.Subst("UpdateButton", "");
        Response.Subst("UpdateButton", SubmitButton("Update", Update));
        ItemList = ItemList $ WebInclude(DefaultsRestrictionsPage $ "_row");
    }

    Response.Subst("ItemList", ItemList);
    Response.Subst("PostAction", DefaultsRestrictionsPage);
    Response.Subst("PageHelp", NoteRestrictionsPage);

    ShowPage(Response, DefaultsRestrictionsPage);
}

defaultproperties
{
    DefaultsRestrictionsPage="defaults_restrictions"
    DefaultsRestrictionsLink="Restrictions"
    NoteRestrictionsPage="Ban players from using selected in-game features"
}

