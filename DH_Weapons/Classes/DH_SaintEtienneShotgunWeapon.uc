//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
//  ART
//==============================================================================
// [ ] Textures
// [ ] Crawl
// [ ] Sprint
// [ ] Melee
// [ ] Third person animations
// [ ] UI
//==============================================================================

class DH_SaintEtienneShotgunWeapon extends DHProjectileWeapon;

var name MuzzleBone2;

function name GetMuzzleBone()
{
    switch (AmmoAmount(0))
    {
        case 2:
            return MuzzleBone;
        default:
            return MuzzleBone2;
    }
}

defaultproperties
{
    TeamIndex=0
    ItemName="Saint Etienne Shotgun"
    FireModeClass(0)=Class'DH_SaintEtienneShotgunFire'
    FireModeClass(1)=Class'DH_SaintEtienneShotgunMeleeFire'
    AttachmentClass=Class'DH_SaintEtienneShotgunAttachment'
    PickupClass=Class'DH_SaintEtienneShotgunPickup'

    Mesh=SkeletalMesh'DH_SaintEtienne_anm.ST_ETIENNE_1ST'

    DisplayFOV=90.0
    IronSightDisplayFOV=75.0

    InitialNumPrimaryMags=5
    MaxNumPrimaryMags=5

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload"

    SprintStartAnimRate=1.0
    SprintEndAnimRate=1.0
    SprintLoopAnimRate=1.0

    WeaponComponentAnimations(0)=(DriverType=DRIVER_MagazineAmmunition,Channel=1,Animation="MAGAZINE_DRIVER",BoneName="MAGAZINE_DRIVER_ROOT")

    MuzzleBone="MUZZLE_L"
    MuzzleBone2="MUZZLE_R"
}