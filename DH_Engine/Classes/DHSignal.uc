//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSignal extends Object
    abstract;

var localized string    SignalName;
var Material            MenuIconMaterial;
var Material            WorldIconMaterial;
var float               DurationSeconds;
var Color               MyColor;
var bool                bIsUnique;
var bool                bShouldShowLabel;
var bool                bShouldShowDistance;
var float               WorldIconScale;
var float               SignalRadiusInMeters;
var bool                bSquadMembersOnly;

static function Material GetWorldIconMaterial(optional Object OptionalObject)
{
    return default.WorldIconMaterial;
}

static function Color GetColor(optional Object OptionalObject)
{
    return default.MyColor;
}

static function bool CanPlayerRecieve(DHPlayer Sender, DHPlayer Recipient)
{
    if (Sender == none || Recipient == none)
    {
        return false;
    }

    if (Sender.GetTeamNum() != Recipient.GetTeamNum())
    {
        // Recipient is not on the same team as the sender.
        return false;
    }

    if (default.bSquadMembersOnly && Sender.GetSquadIndex() != Recipient.GetSquadIndex())
    {
        // Recipient is not in the same squad as the sender.
        return false;
    }

    return true;
}

// Called when this signal is sent.
static function OnSent(DHPlayer PC, Vector Location, optional Object OptionalObject);

defaultproperties
{
    bShouldShowLabel=true
    DurationSeconds=10.0
    WorldIconScale=1.0
    SignalRadiusInMeters=25.0
    bSquadMembersOnly=false
}
