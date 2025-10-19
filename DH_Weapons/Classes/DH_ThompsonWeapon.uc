//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ThompsonWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M1A1 Thompson"
    SwayModifyFactor=0.78 // +0.08
    FireModeClass(0)=Class'DH_ThompsonFire'
    FireModeClass(1)=Class'DH_ThompsonMeleeFire'
    AttachmentClass=Class'DH_ThompsonAttachment'
    PickupClass=Class'DH_ThompsonPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1A1_Thompson' // TODO: there is no specularity mask for this weapon

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=65.0

    DisplayFOV=86.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    InitialBarrels=1
    BarrelClass=Class'DH_ThompsonBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="fire_select"
    SelectFireIronAnim="Iron_fire_select"
    PutDownAnim="put_away"

    MagEmptyReloadAnims(0)="reload_m1a1"
    MagPartialReloadAnims(0)="reload_m1a1"
}
