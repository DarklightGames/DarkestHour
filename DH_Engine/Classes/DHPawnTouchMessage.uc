//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPawnTouchMessage extends ROTouchMessagePlus
    abstract;

var localized array<string> Messages;
var localized string        FallbackPlayerName;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local PlayerController PC;
    local string PlayerName;

    PC = PlayerController(OptionalObject);

    S = Class'DarkestHourGame'.static.ParseLoadingHintNoColor(default.Messages[Switch], PC);

    if (RelatedPRI_1 != none)
    {
        PlayerName = RelatedPRI_1.PlayerName;
    }
    else
    {
        PlayerName = default.FallbackPlayerName;
    }

    S = Repl(S, "{0}", PlayerName);

    return S;
}

defaultproperties
{
    Messages(0)="Press [%THROWMGAMMO%] to resupply {0}"
    Messages(1)="Press [%THROWMGAMMO%] to reload {0}"
    Messages(2)="Press [%THROWMGAMMO%] to resupply and reload {0}"
    FallbackPlayerName="friendly soldier"
}

