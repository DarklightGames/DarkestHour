//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM91Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Carcano Fucile mod. 91"
    SwayModifyFactor=0.63 // +0.03
    SwayBayonetModifier=1.28
    FireModeClass(0)=Class'DH_CarcanoM91Fire'
    FireModeClass(1)=Class'DH_CarcanoM91MeleeFire'
    AttachmentClass=Class'DH_CarcanoM91Attachment'
    PickupClass=Class'DH_CarcanoM91Pickup'

    Mesh=SkeletalMesh'DH_Carcano_anm.CarcanoM91_1st'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0
    ZoomOutTime=0.35

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    PreReloadAnim="reload_half_start"
    FullReloadAnim="reload"
    SingleReloadAnim="reload_half_middle"
    PostReloadAnim="reload_half_end"

    BoltHipLastAnim="bolt_clipfall"
    BoltIronLastAnim="iron_bolt_clipfall"

    WeaponComponentAnimations(0)=(DriverType=DRIVER_Bolt,Channel=1,BoneName="Hammer",Animation="Hammer")

    StripperClipSize=6
}
