//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMineVolume extends ROMineVolume;

var()   bool            bInitiallyActive;   //Will start active if true
var()   bool            bIsAlsoNoArtyVolume;    //Will also stop artillery/mortars rounds from being effective


// Modified to skip over the Super in ROMineVolume as it was always activating the mine volume & instead we need to use our bInitiallyActive setting
// We don't need to do anything here as we can leave it to Reset(), which gets called whenever a new round starts, otherwise we just duplicate the same functionality here
function PostBeginPlay()
{
    super(Volume).PostBeginPlay();
}

// Modified to activate or deactivate the mine volume based on the leveller's setting of bInitiallyActive
// Called whenever a new round starts, including the ResetGame option
function Reset()
{
    if (bInitiallyActive)
    {
        Activate();
    }
    else
    {
        Deactivate();
    }
}

defaultproperties
{
    bInitiallyActive=true
}
