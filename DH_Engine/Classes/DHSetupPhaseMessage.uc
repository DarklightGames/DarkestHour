//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
            return Repl(default.PhaseMessage, "{0}", ExtraInteger);
        case 1:
            return Repl(default.PhaseEndMessage, "{0}", ExtraInteger);
    }

    return "";
}

defaultproperties
{
    PhaseMessage="Round Begins In: {0} seconds"
    PhaseEndMessage="Round Has Started! Your team begins with {0} reinforcements."

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

