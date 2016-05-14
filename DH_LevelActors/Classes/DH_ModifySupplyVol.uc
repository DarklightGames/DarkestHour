//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ModifySupplyVol extends DH_ModifyActors;

var()   name                    SupplyVolumeToModify;
var     ROAmmoResupplyVolume    SupplyVolumeReference;
var()   bool                    UseRandomness;
var()   int                     RandomPercent; // 100 for always succeed, 0 for always fail
var()   StatusModifyType        HowToModify;

function PostBeginPlay()
{
    local ROAmmoResupplyVolume  RORV;

    super.PostBeginPlay();

    if (SupplyVolumeToModify != '')
    {
        foreach AllActors(class'ROAmmoResupplyVolume', RORV, SupplyVolumeToModify) // volumes are static so have to use the all actor list
        {
            SupplyVolumeReference = RORV;
            break;
        }
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    if (UseRandomness)
    {
        RandomNum = Rand(101);  // gets a random # between 0 & 100

        if (RandomPercent <= RandomNum)
        {
            return; // leave script as it randomly failed
        }
    }

    switch (HowToModify)
    {
        case SMT_Activate:
            SupplyVolumeReference.bActive = true;
            break;

        case SMT_Deactivate:
            SupplyVolumeReference.bActive = false;
            break;

        case SMT_Toggle:
            SupplyVolumeReference.bActive = !SupplyVolumeReference.bActive;
            break;
    }
}

defaultproperties
{
}
