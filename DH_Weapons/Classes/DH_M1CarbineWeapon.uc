//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M1CarbineWeapon extends DHProjectileWeapon;

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    // The M1 and M1/T17 share a mesh, but the fire switch only exists on the
    // M1/T17, therefore we hide the switch in code here.
    SetBoneScale(0, 0.0, 'Fireswitch');
}

defaultproperties
{
    ItemName="M1 Carbine"
    SwayModifyFactor=0.45 // -0.25  because it was a very light carbine
    FireModeClass(0)=class'DH_Weapons.DH_M1CarbineFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1CarbineMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1CarbineAttachment'
    PickupClass=class'DH_Weapons.DH_M1CarbinePickup'

    Mesh=SkeletalMesh'DH_M1Carbine_1st.M1Carbine_mesh'
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.M1Carbine'
    Skins(3)=Texture'DH_Weapon_tex.AlliedSmallArms.M1CarbineExtra'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=40.0
    DisplayFOV=90.0
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12

    PutDownAnim="put_away"
    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"

    MuzzleBone="MuzzleNew2"

    bPlusOneLoading=true
}
