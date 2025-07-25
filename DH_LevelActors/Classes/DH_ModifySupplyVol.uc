//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ModifySupplyVol extends DH_ModifyActors;

var()   name                    SupplyVolumeToModify;
var     ROAmmoResupplyVolume    SupplyVolumeReference;
var()   bool                    UseRandomness;
var()   int                     RandomPercent; // 100 for always succeed, 0 for always fail
var()   StatusModifyType        HowToModify;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (SupplyVolumeToModify != '')
    {
        foreach AllActors(Class'ROAmmoResupplyVolume', SupplyVolumeReference, SupplyVolumeToModify) // volumes are static so have to use the all actor list
        {
            break;
        }
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    if (UseRandomness)
    {
        RandomNum = Rand(100);  // Gets a random # between 0 & 99

        if (RandomPercent < RandomNum)
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


