//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMineVolume extends ROMineVolume;

var()   bool            bInitiallyActive;   //Will start active if true
var()   bool            bIsAlsoNoArtyVolume;    //Will also stop artillery/mortars rounds from being effective

function PostBeginPlay()
{
    super.PostBeginPlay();

    bActive = bInitiallyActive;
}

//Override to prevent ROTeamGame from changing bActive
function Activate()
{
    if (bUsesSpawnAreas)
        bActive = true;
}

//Override to prevent ROTeamGame from changing bActive
function Deactivate()
{
    if (bUsesSpawnAreas)
        bActive = false;
}

function Reset()
{
    bActive = bInitiallyActive;
}

defaultproperties
{
    bInitiallyActive=true
}
