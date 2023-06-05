//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionProgressMessage extends LocalMessage
    abstract;

var localized string ProgressMessage;

// Modified to show appropriate weapons locked/unlocked message based on passed Switch value
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHConstruction Construction;
    local string S;


    switch (Switch)
    {
        case 0:
            Construction = DHConstruction(OptionalObject);
            S = Repl(default.ProgressMessage, "{0}", Construction.Progress + 1);
            S = Repl(S, "{1}", Construction.ProgressMax);
            return S;
    }

    return "";
}


defaultproperties
{
    bFadeMessage=true
    bIsConsoleMessage=false
    bIsUnique=true
    Lifetime=2.0
    PosY=0.9
    ProgressMessage="Progress: {0} / {1}"
}
