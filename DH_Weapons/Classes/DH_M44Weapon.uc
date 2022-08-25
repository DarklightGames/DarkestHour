//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M44Weapon extends DHBoltActionWeapon;

// Modified as this rifle has a fixed bayonet
exec simulated function Deploy()
{
}

defaultproperties
{
    ItemName="Mosin M44 Carbine"
    FireModeClass(0)=class'DH_Weapons.DH_M44Fire'
    FireModeClass(1)=class'DH_Weapons.DH_M44MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M44Attachment'
    PickupClass=class'DH_Weapons.DH_M44Pickup'

    Mesh=SkeletalMesh'DH_Nagant_1st.Mosin_Nagant_M44'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.MN9138_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0
    ZoomOutTime=0.35
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10

    bHasBayonet=true
    bBayonetMounted=true
    BayonetBoneName="bayonet"

    PreReloadAnim="single_open"
    FullReloadAnim="reload"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}
