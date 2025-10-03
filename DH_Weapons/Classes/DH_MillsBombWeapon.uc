//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MillsBombWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="Mills Bomb"
    FireModeClass(0)=Class'DH_MillsBombFire'
    FireModeClass(1)=Class'DH_MillsBombTossFire'
    AttachmentClass=Class'DH_MillsBombAttachment'
    PickupClass=Class'DH_MillsBombPickup'
    Mesh=SkeletalMesh'DH_MillsBomb.MillsBomb'
    DisplayFOV=80.0
    FuzeLengthRange=(Min=4.0,Max=4.0)
    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0

    GroupOffset=2
}

