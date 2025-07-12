//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1928_20rndWeapon extends DHFastAutoWeapon;

simulated function bool StartFire(int Mode)
{
    if (super(DHProjectileWeapon).StartFire(Mode))
    {
        if (FireMode[Mode].bMeleeMode)
        {
            return true;
        }

        AnimStopLooping();

        // single
        if (FireMode[0].bWaitForRelease)
        {
            return true;
        }
        else // auto
        {
            if (!FireMode[Mode].IsInState('FireLoop'))
            {
                FireMode[Mode].StartFiring();
                return true;
            }
        }
    }

    return false;
}

defaultproperties
{
    ItemName="M1928A1 Thompson (20rd)"
    SwayModifyFactor=0.75 // +0.05
    FireModeClass(0)=Class'DH_M1928_20rndFire'
    FireModeClass(1)=Class'DH_ThompsonMeleeFire'
    AttachmentClass=Class'DH_M1928_20rndAttachment'
    PickupClass=Class'DH_M1928_20rndPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1928_20rnd'

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=65.0

    DisplayFOV=86.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9
    bCanHaveInitialNumMagsChanged=false  //adding this to provide some benefit over the 30 rounder

    InitialBarrels=1
    BarrelClass=Class'DH_ThompsonBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="fire_select"
    SelectFireIronAnim="Iron_fire_select"
    PutDownAnim="put_away"

    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    HandNum=0
    SleeveNum=1
    HighDetailOverlayIndex=2
}
