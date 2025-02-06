//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Air-cooled, belt-fed version of the Fiat 14/35 MG
//==============================================================================

class DH_Fiat1435MG_AC extends DH_Fiat1435MG;

defaultproperties
{
    RangeTable(0)=(Range=100.0,AnimationTime=0.000)
    RangeTable(1)=(Range=200.0,AnimationTime=0.010)
    RangeTable(2)=(Range=300.0,AnimationTime=0.020)
    RangeTable(3)=(Range=400.0,AnimationTime=0.040)
    RangeTable(4)=(Range=500.0,AnimationTime=0.060)
    RangeTable(5)=(Range=600.0,AnimationTime=0.080)
    RangeTable(6)=(Range=700.0,AnimationTime=0.110)
    RangeTable(7)=(Range=800.0,AnimationTime=0.140)
    RangeTable(8)=(Range=900.0,AnimationTime=0.175)
    RangeTable(9)=(Range=1000.0,AnimationTime=0.215)

    InitialPrimaryAmmo=300
    NumMGMags=3
    ReloadSequence="RELOAD_WC"  // TODO: replace with "RELOAD_AC"
    Mesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_AC_3RD'
    WeaponFireAttachmentBone="MUZZLE_AC"
    WeaponFireOffset=-10.0

    AmmoRoundStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_BELT_LINK_1ST'
    AmmoRoundBones(0)="BELT_01"
    AmmoRoundBones(1)="BELT_02"
    AmmoRoundBones(2)="BELT_03"
    AmmoRoundBones(3)="BELT_04"
    AmmoRoundBones(4)="BELT_05"
    AmmoRoundBones(5)="BELT_06"
    AmmoRoundBones(6)="BELT_07"
    AmmoRoundBones(7)="BELT_08"
    AmmoRoundBones(8)="BELT_09"
    AmmoRoundBones(9)="BELT_10"
    AmmoRoundBones(10)="BELT_11"
    AmmoRoundBones(11)="BELT_12"
    AmmoRoundBones(12)="BELT_13"
    AmmoRoundBones(13)="BELT_14"
    AmmoRoundBones(14)="BELT_15"
    // CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_GUN_WC_COLLISION_YAW',AttachBone="MG_YAW")
    // HudAltAmmoIcon=Texture'DH_Fiat1435_tex.fiat1435_wc_ammo_icon'

    EmptyAmmoRoundStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_BELT_LINK_EMPTY_1ST'
    EmptyAmmoRoundBones(0)="BELT_EMPTY_01"
    EmptyAmmoRoundBones(1)="BELT_EMPTY_02"
    EmptyAmmoRoundBones(2)="BELT_EMPTY_03"
    EmptyAmmoRoundBones(3)="BELT_EMPTY_04"
    EmptyAmmoRoundBones(4)="BELT_EMPTY_05"
    EmptyAmmoRoundBones(5)="BELT_EMPTY_06"
    EmptyAmmoRoundBones(6)="BELT_EMPTY_07"
    EmptyAmmoRoundBones(7)="BELT_EMPTY_08"
    EmptyAmmoRoundBones(8)="BELT_EMPTY_09"
    EmptyAmmoRoundBones(9)="BELT_EMPTY_10"
    EmptyAmmoRoundBones(10)="BELT_EMPTY_11"
    EmptyAmmoRoundBones(11)="BELT_EMPTY_12"
    EmptyAmmoRoundBones(12)="BELT_EMPTY_13"
    EmptyAmmoRoundBones(13)="BELT_EMPTY_14"
    EmptyAmmoRoundBones(14)="BELT_EMPTY_15"
    EmptyAmmoRoundBones(15)="BELT_EMPTY_16"
    EmptyAmmoRoundBones(16)="BELT_EMPTY_17"
    EmptyAmmoRoundBones(17)="BELT_EMPTY_18"
    EmptyAmmoRoundBones(18)="BELT_EMPTY_19"
    EmptyAmmoRoundBones(19)="BELT_EMPTY_20"
    EmptyAmmoRoundBones(20)="BELT_EMPTY_21"
    
    EmptyAmmoRoundRelativeRotation=(Roll=32768)

    BeltChannel=3
    BeltBone="BELT_ROOT"
    BeltIdleAnimation="BELT_IDLE"
    BeltFireLoopAnimation="BELT_FIRE_LOOP"
    BeltFireEndAnimation="BELT_FIRE_END"
}
