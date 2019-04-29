//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_EnfieldNo4Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Lee Enfield No.4 Rifle"
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4Fire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4Attachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo4Pickup'

    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4'
    Skins(3)=Shader'Weapons1st_tex.Bullets.kar98k_stripper_s' // TODO: ammo & bayo specularity shaders aren't used in the anim mesh & should be added there
    Skins(1)=Shader'DH_EnfieldNo4_tex.EnfieldNo4.EnfieldNo4Bayonet_s'
    Skins(0)=Shader'DH_EnfieldNo4_tex.EnfieldNo4.EnfieldNo4_s'
    HighDetailOverlay=Shader'DH_EnfieldNo4_tex.EnfieldNo4.EnfieldNo4_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0

    HandNum=5
    SleeveNum=4

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    IronSightDisplayFOV=40.0
    IronSightDisplayFOVHigh=40.0

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    IronBringUpRest="iron_inrest"

    PreReloadAnim="reload_start"
    PostReloadAnim="reload_end"
    SingleReloadAnim="reload_single"
    StripperReloadAnim="reload_stripper"
}
