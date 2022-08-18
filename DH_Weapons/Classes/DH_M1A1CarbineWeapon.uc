//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M1A1CarbineWeapon extends DHProjectileWeapon;

defaultproperties
{
    ItemName="M1A1 Carbine"
    SwayModifyFactor=0.49 // +0.04 from m1 because the stock is less convenient
    FireModeClass(0)=class'DH_Weapons.DH_M1A1CarbineFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1A1CarbineMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1A1CarbineAttachment'
    PickupClass=class'DH_Weapons.DH_M1A1CarbinePickup'

    Mesh=SkeletalMesh'DH_M1Carbine_1st.M1A1Carbine_mesh'
    Skins(0)=Texture'DH_Weapon_tex.AlliedSmallArms.M1A1Carbine'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=40.0
    DisplayFOV=90.0
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12

    PutDownAnim="put_away"
    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"

    MuzzleBone="MuzzleNew"
    FirstSelectAnim="Draw2"

    SleeveNum=1
    HandNum=2

    bPlusOneLoading=true
}
