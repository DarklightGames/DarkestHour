//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ModifyRoundTimeMessage extends ROCriticalMessage
    abstract;

var localized string    IncreasedText;
var localized string    DecreasedText;
var localized string    ChangedText;
var localized string    RoundTimeModifiedText;

//The sound to play when this actor is triggered.
var Sound               Sound;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    S = default.RoundTimeModifiedText;

    switch (Switch)
    {
        case 0:
            S = Repl(S, "{0}", default.IncreasedText);
        case 1:
            S = Repl(S, "{0}", default.DecreasedText);
        case 2:
            S = Repl(S, "{0}", default.ChangedText);
        default:
            S = Repl(S, "{0}", default.ChangedText);
    }

    return S;
}

simulated static function ClientReceive(PlayerController P, optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    P.PlayAnnouncement(default.Sound, 1, true);
}

defaultproperties
{
    Sound=Sound'Miscsounds.notify_drum'
    IncreasedText="increased"
    DecreasedText="decreased"
    ChangedText="changed"
    RoundTimeModifiedText="Time remaining has been {0}."
}
