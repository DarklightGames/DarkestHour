//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehiclePoolMessage extends ROGameMessage
    abstract;

var localized string ActivatedMessage;
var localized string DestroyedMessage;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    switch (Switch)
    {
        case 0:
            return default.ActivatedMessage;
        case 3:
            return default.DestroyedMessage;
    }

    return "";
}

defaultproperties
{
    DrawColor=(R=225,G=105,B=45,A=255)
    ActivatedMessage="A Vehicle Pool has been activated."
    DestroyedMessage="A Vehicle Pool has been destroyed."
}

