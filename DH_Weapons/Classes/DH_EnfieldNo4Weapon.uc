//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_EnfieldNo4Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Lee Enfield No.4 Rifle"
    SwayModifyFactor=0.62 // +0.02
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4Fire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4Attachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo4Pickup'

    Mesh=SkeletalMesh'DH_EnfieldNo4_anm.EnfieldNo4_1st'

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8  //reduced from 13 because this rifle used to have x2 as much ammo as other rifles

    IronSightDisplayFOV=40.0
    DisplayFOV=85.0

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    IronBringUpRest="iron_inrest"

    PreReloadCockedAnim="reload_start_cocked"
    PreReloadAnim="reload_start"
    PostReloadAnim="reload_end"
    SingleReloadAnim="reload_single"
    StripperReloadAnim="reload_stripper"

    WeaponComponentAnimations(0)=(DriverType=DRIVER_Bolt,Channel=2,BoneName="cocker",Animation="cocker")
}
