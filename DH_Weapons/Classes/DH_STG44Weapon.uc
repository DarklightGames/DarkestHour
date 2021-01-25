//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_STG44Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Sturmgewehr 44"
    FireModeClass(0)=class'DH_Weapons.DH_STG44Fire'
    FireModeClass(1)=class'DH_Weapons.DH_STG44MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_STG44Attachment'
    PickupClass=class'DH_Weapons.DH_STG44Pickup'

    Mesh=SkeletalMesh'DH_Stg44_1st.STG44-Mesh'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.STG44_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=35.0
    DisplayFOV=90.0
    ZoomOutTime=0.1
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"

    bSniping=true // for bots (as has longer range than other auto weapons)
}
