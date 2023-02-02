//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSetupPhaseMessage extends LocalMessage;

var localized string    PhaseMessage;       // Message to send periodically when phase is current
var localized string    PhaseEndMessage;    // Message to send to team when end is reached

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local int S, ExtraInteger;

    class'UInteger'.static.ToShorts(Switch, S, ExtraInteger);

    switch (S)
    {
        case 0:
            return Repl(default.PhaseMessage, "{0}", class'TimeSpan'.static.ToString(ExtraInteger));
        case 1:
            return default.PhaseEndMessage;
    }

    return "";
}

defaultproperties
{
    PhaseMessage="The battle begins in {0}"
    PhaseEndMessage="The battle has begun!"
    bBeep=false
    bFadeMessage=true
    bIsUnique=true
    bIsConsoleMessage=false
    DrawColor=(R=255,G=255,B=255,A=255)
    FontSize=1
    LifeTime=5
    PosX=0.5
    PosY=0.75  // used to be 0.5, moved to get it out of the middle
}

