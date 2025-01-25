//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    // CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_GUN_WC_COLLISION_YAW',AttachBone="MG_YAW")
    // HudAltAmmoIcon=Texture'DH_Fiat1435_tex.fiat1435_wc_ammo_icon'
}
