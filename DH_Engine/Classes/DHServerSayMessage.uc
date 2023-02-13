//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHServerSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    return default.MessagePrefix @ ":" @ MessageString;
}

static function color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    DrawColor=(B=10,G=220,R=220,A=255)
    MessagePrefix="[SERVER]"
    bComplexString=true
    Lifetime=20
}
