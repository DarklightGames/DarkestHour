//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM9138CarbineWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Carcano Moschetto mod. 91/38"
    SwayModifyFactor=0.49 // -0.11
    SwayBayonetModifier=1.06
    FireModeClass(0)=Class'DH_CarcanoM9138CarbineFire'
    FireModeClass(1)=Class'DH_CarcanoM9138CarbineMeleeFire'
    AttachmentClass=Class'DH_CarcanoM9138CarbineAttachment'
    PickupClass=Class'DH_CarcanoM9138CarbinePickup'

    Mesh=SkeletalMesh'DH_Carcano_anm.CarcanoM9138Carbine_1st'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0
    ZoomOutTime=0.35

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on_carbine"
    BayoDetachAnim="Bayonet_off_carbine"

    PreReloadAnim="reload_half_start"
    FullReloadAnim="reload"
    SingleReloadAnim="reload_half_middle"
    PostReloadAnim="reload_half_end"

    BoltHipLastAnim="bolt_clipfall"
    BoltIronLastAnim="iron_bolt_clipfall"

    WeaponComponentAnimations(0)=(DriverType=DRIVER_Bolt,Channel=1,BoneName="Hammer",Animation="Hammer")
    WeaponComponentAnimations(1)=(DriverType=DRIVER_Bayonet,Channel=2,BoneName="folding_bayonet_car",Animation="Bayonet_unfolded_carbine")

    StripperClipSize=6
}
