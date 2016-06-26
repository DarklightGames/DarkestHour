//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40JamMessage extends LocalMessage;

var localized string    JamMessage;
var localized string    NoMessage;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    switch(Switch)
    {
        case 0:
            return Default.JamMessage;
        case 1:
            return Default.NoMessage;
    }
}

defaultproperties
{
     JamMessage="Weapon Jammed! Reload"
     NoMessage="An error in the jamming system has occured, please report"
     bIsUnique=True
     bIsConsoleMessage=False
     Lifetime=3
     PosX=0.50000
     PosY=0.750000
     FontSize=-2
}
