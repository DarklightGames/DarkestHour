//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Third person model & animations
//==============================================================================

class DH_BerettaM1934Weapon extends DHPistolWeapon;

defaultproperties
{
    TeamIndex=0
    ItemName="Beretta M1934"
    FireModeClass(0)=class'DH_Weapons.DH_BerettaM1934Fire'
    FireModeClass(1)=class'DH_Weapons.DH_BerettaM1934MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BerettaM1934Attachment'
    PickupClass=class'DH_Weapons.DH_BerettaM1934Pickup'

    Mesh=SkeletalMesh'DH_BerettaM1934_anm.Beretta_M1934_1st'

    BeltBulletClass=class'DH_Weapons.DH_BerettaM1934FPAmmoRound'
    MGBeltBones(0)="MAGAZINE_BULLET_07"
    MGBeltBones(1)="MAGAZINE_BULLET_06"
    MGBeltBones(2)="MAGAZINE_BULLET_05"
    MGBeltBones(3)="MAGAZINE_BULLET_04"
    MGBeltBones(4)="MAGAZINE_BULLET_03"
    MGBeltBones(5)="MAGAZINE_BULLET_02"
    MGBeltBones(6)="MAGAZINE_BULLET_01"

    DisplayFOV=90.0
    IronSightDisplayFOV=75.0

    InitialNumPrimaryMags=5
    MaxNumPrimaryMags=5

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload"

    SprintStartAnimRate=1.0
    SprintEndAnimRate=1.0
    SprintLoopAnimRate=1.0

    WeaponComponentAnimations(0)=(DriverType=DRIVER_MagazineAmmunition,Channel=1,Animation="driver_magazine",BoneName="MAGAZINE_INTERNALS")
    WeaponComponentAnimations(1)=(DriverType=DRIVER_Slide,Channel=2,Animation="driver_slide",BoneName="SLIDE",bStartMuted=true)
}
