//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M1T17CarbineWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M1/T17 Automatic Carbine"
    SwayModifyFactor=0.45 // -0.25  because it was a very light carbine
    FireModeClass(0)=class'DH_Weapons.DH_M1T17CarbineFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1T17CarbineMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1T17CarbineAttachment'
    PickupClass=class'DH_Weapons.DH_M1T17CarbinePickup'

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

    bHasSelectFire=true
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"

    FireSelectSwitchBoneName="Fireswitch"
    FireSelectAutoRotation=(Yaw=-3000)
    FireSelectSemiRotation=(Yaw=300)
}
