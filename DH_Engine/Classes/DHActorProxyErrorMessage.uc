//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHActorProxyErrorMessage extends LocalMessage
    abstract;

var localized string NoGroundMessage;
var localized string TooSteepMessage;
var localized string InWaterMessage;
var localized string NoRoomMessage;
var localized string NotOnTerrainMessage;
var localized string InMinefieldMessage;
var localized string NearSpawnPointMessage;
var localized string IndoorsMessage;
var localized string InObjectiveMessage;
var localized string BadSurfaceMessage;
var localized string BadTerrainMessage;
var localized string InDangerZoneMessage;
var localized string SocketOccupiedMessage;
var localized string RestrictedMessage;
var localized string TooCloseFriendlyMessage;
var localized string TooCloseEnemyMessage;
var localized string MaxActiveMessage;
var localized string InsufficientSupplyMessage;
var localized string RestrictedTypeMessage;
var localized string SquadTooSmallMessage;
var localized string PlayerBusyMessage;
var localized string TooCloseToObjectiveMessage;
var localized string TooCloseToEnemyObjectiveMessage;
var localized string MissingRequirementMessage;
var localized string ExhaustedMessage;

static function string GetStringFromType(DHActorProxy.EActorProxyErrorType Type)
{
    switch(Type)
    {
        case ERROR_NoGround:
            return default.NoGroundMessage;
        case ERROR_TooSteep:
            return default.TooSteepMessage;
        case ERROR_InWater:
            return default.InWaterMessage;
        case ERROR_NoRoom:
            return default.NoRoomMessage;
        case ERROR_NotOnTerrain:
            return default.NotOnTerrainMessage;
        case ERROR_InMinefield:
            return default.InMinefieldMessage;
        case ERROR_NearSpawnPoint:
            return default.NearSpawnPointMessage;
        case ERROR_Indoors:
            return default.IndoorsMessage;
        case ERROR_InObjective:
            return default.InObjectiveMessage;
        case ERROR_BadSurface:
            return default.BadSurfaceMessage;
        case ERROR_BadTerrain:
            return default.BadTerrainMessage;
        case ERROR_InDangerZone:
            return default.InDangerZoneMessage;
        case ERROR_SocketOccupied:
            return default.SocketOccupiedMessage;
        case ERROR_Restricted:
            return default.RestrictedMessage;
        case ERROR_TooCloseFriendly:
            return default.TooCloseFriendlyMessage;
        case ERROR_TooCloseEnemy:
            return default.TooCloseEnemyMessage;
        case ERROR_MaxActive:
            return default.MaxActiveMessage;
        case ERROR_InsufficientSupply:
            return default.InsufficientSupplyMessage;
        case ERROR_RestrictedType:
            return default.RestrictedTypeMessage;
        case ERROR_SquadTooSmall:
            return default.SquadTooSmallMessage;
        case ERROR_PlayerBusy:
            return default.PlayerBusyMessage;
        case ERROR_TooCloseToObjective:
            return default.TooCloseToObjectiveMessage;
        case ERROR_TooCloseToEnemyObjective:
            return default.TooCloseToEnemyObjectiveMessage;
        case ERROR_MissingRequirement:
            return default.MissingRequirementMessage;
        case ERROR_Exhausted:
            return default.ExhaustedMessage;
        default:
            return "";
    }
}

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHActorProxy ActorProxy;
    local string Result;

    ActorProxy = DHActorProxy(OptionalObject);

    if (ActorProxy.ProxyError.Type == ERROR_Custom)
    {
        Result = ActorProxy.ProxyError.CustomErrorString;
    }
    else
    {
        Result = GetStringFromType(ActorProxy.ProxyError.Type);
    }

    Result = Repl(Result, "{name}", ActorProxy.GetMenuName());
    Result = Repl(Result, "{verb}", ActorProxy.GetMenuVerb());
    Result = Repl(Result, "{integer}", ActorProxy.ProxyError.OptionalInteger);
    Result = Repl(Result, "{string}", ActorProxy.ProxyError.OptionalString);

    return Result;
}

static function RenderComplexMessage(
    Canvas Canvas,
    out float XL,
    out float YL,
    optional String MessageString,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local float X, Y;

    X = Canvas.CurX;
    Y = Canvas.CurY;

    Canvas.DrawColor = default.DrawColor;
    Canvas.SetPos(X, Y);
    Canvas.DrawText(MessageString);
}

defaultproperties
{
    bFadeMessage=false
    bIsUnique=true
    bIsConsoleMessage=false
    bComplexString=true
    DrawColor=(R=255,G=255,B=255,A=255)
    FontSize=-2
    Lifetime=0.25
    PosY=0.80

    NoGroundMessage="You must {verb} a {name} on solid ground."
    TooSteepMessage="The ground is too steep here to {verb} a {name}."
    InWaterMessage="You cannot {verb} a {name} in water."
    RestrictedMessage="You cannot {verb} a {name} at this location."
    NoRoomMessage="Not enough room here to {verb} a {name}."
    NotOnTerrainMessage="You must {verb} a {name} on earthen terrain."
    TooCloseFriendlyMessage="Too close to an existing friendly {name}, it must be {integer}m further away."
    TooCloseEnemyMessage="Too close to an existing enemy {name}, it must be {integer}m further away."
    InMinefieldMessage="You cannot {verb} a {name} in a minefield."
    NearSpawnPointMessage="You cannot {verb} a {name} near a spawn point."
    IndoorsMessage="You cannot {verb} a {name} indoors."
    InObjectiveMessage="You cannot {verb} a {name} inside an objective."
    MaxActiveMessage="Your team cannot {verb} any more {name} (limit reached: {integer})."
    InsufficientSupplyMessage="There are insufficient supplies to {verb} a {name}."
    BadSurfaceMessage="You cannot {verb} a {name} on this surface."
    BadTerrainMessage="The ground is too hard to {verb} a {name} at this location."
    SquadTooSmallMessage="You must have {integer} members in your squad to {verb} a {name}."
    PlayerBusyMessage="You cannot {verb} a {name} while you are busy."
    TooCloseToObjectiveMessage="Too close to an objective ({string}), it must be {integer}m further away."
    TooCloseToEnemyObjectiveMessage="Too close to an uncontrolled objective ({string}), it must be {integer}m further away."
    MissingRequirementMessage="You must {verb} a {name} within {integer}m of a friendly {string}"
    InDangerZoneMessage="You cannot {verb} a {name} in enemy territory"
    ExhaustedMessage="There are no more {name} available"
    SocketOccupiedMessage="This socket is already occupied"
}
