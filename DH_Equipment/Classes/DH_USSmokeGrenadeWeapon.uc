//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSmokeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="M8 Smoke Grenade"
    FireModeClass(0)=Class'DH_USSmokeGrenadeFire'
    FireModeClass(1)=Class'DH_USSmokeGrenadeTossFire'
    PickupClass=Class'DH_USSmokeGrenadePickup'
    AttachmentClass=Class'DH_USSmokeGrenadeAttachment'
    Mesh=SkeletalMesh'DH_M8Grenade_1st.M8'

    HandNum=0
    SleeveNum=2

    InventoryGroup=4
    GroupOffset=2
    Priority=2

    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    DisplayFOV=80.0
    FuzeLengthRange=(Min=2.0,Max=2.0)
}

