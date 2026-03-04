//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [1] https://en.wikipedia.org/wiki/Glisenti_Model_1910
//==============================================================================

class DH_GlisentiM1910Weapon extends DHPistolWeapon;

defaultproperties
{
    TeamIndex=0
    ItemName="Glisenti mod. 1910"
    FireModeClass(0)=Class'DH_GlisentiM1910Fire'
    FireModeClass(1)=Class'DH_GlisentiM1910MeleeFire'
    AttachmentClass=Class'DH_GlisentiM1910Attachment'
    PickupClass=Class'DH_GlisentiM1910Pickup'

    Mesh=SkeletalMesh'DH_GlisentiM1910_anm.GLISENTI_M1910_1ST'

    BeltBulletClass=Class'DH_BerettaM1934FPAmmoRound'   // TODO: replace with Glisenti bullet.
    // MGBeltBones(0)="MAGAZINE_BULLET_07"
    // MGBeltBones(1)="MAGAZINE_BULLET_06"
    // MGBeltBones(2)="MAGAZINE_BULLET_05"
    // MGBeltBones(3)="MAGAZINE_BULLET_04"
    // MGBeltBones(4)="MAGAZINE_BULLET_03"
    // MGBeltBones(5)="MAGAZINE_BULLET_02"
    // MGBeltBones(6)="MAGAZINE_BULLET_01"

    DisplayFOV=90.0
    IronSightDisplayFOV=75.0

    InitialNumPrimaryMags=3
    MaxNumPrimaryMags=3

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload"

    SprintStartAnimRate=1.0
    SprintEndAnimRate=1.0
    SprintLoopAnimRate=1.0

    WeaponComponentAnimations(0)=(DriverType=DRIVER_MagazineAmmunition,Channel=1,Animation="DRIVER_MAGAZINE",BoneName="MAGAZINE_INTERNALS")
    WeaponComponentAnimations(1)=(DriverType=DRIVER_Slide,Channel=2,Animation="DRIVER_SLIDE",BoneName="SLIDE",bStartMuted=true)
}
