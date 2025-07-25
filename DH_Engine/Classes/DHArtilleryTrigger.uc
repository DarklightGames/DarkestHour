//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This is now a deprecated pass-through class that spawns a DHRadio in it's
// place to maintain backwards compatibility with old maps.
//==============================================================================

class DHArtilleryTrigger extends ROArtilleryTrigger;

var()   bool        bShouldShowOnSituationMap;    // whether HUD overhead map should show an icon to mark this arty trigger's position

function PostBeginPlay()
{
    local DHRadio Radio;

    if (Role == ROLE_Authority)
    {
        Radio = Spawn(Class'DHRadio', Owner, Tag, Location, Rotation);

        if (Radio == none)
        {
            Error("Failed to spawn DHRadio from DHArtilleryTrigger!");
        }

        Radio.TeamIndex = int(TeamCanUse);
        Radio.bShouldShowOnSituationMap = bShouldShowOnSituationMap;

        Destroy();
    }
}

defaultproperties
{
    bShouldShowOnSituationMap=true
}
