//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M9531Weapon extends DHBoltActionWeapon; 
//Hungarian 1931 modification of Mannlicher M95
//Meant for hungarian loadouts (not volkssturm)

defaultproperties
{
    ItemName="31.M Rifle"
    NativeItemName="31.M Puska"
    SwayModifyFactor=0.50  // -0.10

    FireModeClass(0)=class'DH_Weapons.DH_M9531Fire'
    FireModeClass(1)=class'DH_Weapons.DH_M9531MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M9531Attachment'
    PickupClass=class'DH_Weapons.DH_M9531Pickup'

    Mesh=SkeletalMesh'DH_Mannlicher_1st.m9531_mesh'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=47.0
    DisplayFOV=84.0
    ZoomOutTime=0.35

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12
    
    IronBringUpRest="iron_inrest"

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
}
