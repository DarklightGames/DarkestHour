//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Water-cooled, clip-fed version of the Fiat 14/35.
//==============================================================================

class DH_Fiat1435MG_WC extends DH_Fiat1435MG;

defaultproperties
{
    InitialPrimaryAmmo=50
    NumMGMags=20

    ReloadSequence="RELOAD_WC"

    Mesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_3RD'

    WeaponFireAttachmentBone="MUZZLE_WC"
    WeaponFireOffset=-10.0

    ClipBone="CLIP"
    ClipAnim="CLIP_DRIVER"
    ClipChannel=3

    RoundsInStaticMesh=5
    AmmoRoundStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_CLIP_CARTRIDGE_1ST'
    AmmoRoundBones(0)="CLIP_CARTRIDGES_10"
    AmmoRoundBones(1)="CLIP_CARTRIDGES_09"
    AmmoRoundBones(2)="CLIP_CARTRIDGES_08"
    AmmoRoundBones(3)="CLIP_CARTRIDGES_07"
    AmmoRoundBones(4)="CLIP_CARTRIDGES_06"
    AmmoRoundBones(5)="CLIP_CARTRIDGES_05"
    AmmoRoundBones(6)="CLIP_CARTRIDGES_04"
    AmmoRoundBones(7)="CLIP_CARTRIDGES_03"
    AmmoRoundBones(8)="CLIP_CARTRIDGES_02"
    AmmoRoundBones(9)="CLIP_CARTRIDGES_01"

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_GUN_WC_COLLISION_YAW',AttachBone="MG_YAW")

    HudAltAmmoIcon=Texture'DH_Fiat1435_tex.fiat1435_wc_ammo_icon'

}
