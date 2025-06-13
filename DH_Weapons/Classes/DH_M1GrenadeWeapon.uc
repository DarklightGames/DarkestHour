//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="Mk II Grenade"
    FireModeClass(0)=Class'DH_M1GrenadeFire'
    FireModeClass(1)=Class'DH_M1GrenadeTossFire'
    AttachmentClass=Class'DH_M1GrenadeAttachment'
    PickupClass=Class'DH_M1GrenadePickup'
    DisplayFOV=80.0

    Mesh=SkeletalMesh'DH_M1Grenade_1st.M1_Grenade'
    Skins(2)=Texture'DH_Weapon_tex.M1Grenade' // TODO: there is no specularity mask for this weapon

    SleeveNum=0
    HandNum=1

    FuzeLengthRange=(Min=4.0,Max=4.0)
    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0

    GroupOffset=1
}
