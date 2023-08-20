//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_CarcanoM91Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Carcano M91"
    SwayModifyFactor=0.63 // +0.03
    SwayBayonetModifier=1.28
    FireModeClass(0)=class'DH_Weapons.DH_CarcanoM91Fire'
    FireModeClass(1)=class'DH_Weapons.DH_CarcanoM91MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_CarcanoM91Attachment'
    PickupClass=class'DH_Weapons.DH_CarcanoM91Pickup'

    Mesh=SkeletalMesh'DH_Carcano_1st.CarcanoM91_1st'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0
    ZoomOutTime=0.35

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10
    
    IronBringUpRest="iron_inrest"

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    PreReloadAnim="reload_half_start"
    FullReloadAnim="reload"
    SingleReloadAnim="reload_half_middle"
    PostReloadAnim="reload_half_end"
}
