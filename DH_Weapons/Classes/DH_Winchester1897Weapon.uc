//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Winchester1897Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Winchester Model 1897"
    FireModeClass(0)=class'DH_Weapons.DH_Winchester1897Fire'
    FireModeClass(1)=class'DH_Weapons.DH_Winchester1897MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Winchester1897Attachment'
    PickupClass=class'DH_Weapons.DH_Winchester1897Pickup'

    Mesh=SkeletalMesh'DH_Winchester1897_anm.Winchester1897_1st'

    DisplayFOV=90.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=50.0
    BobModifyFactor=0.4

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

    PutDownAnim="put_away"

    IronBringUp="iron_in"
//  IronBringUpRest="Post_fire_iron_in" // TODO: ideally should have this, with hammer up after firing (played when ironsighting while waiting to work the pump action)
    IronIdleAnim="Iron_idle"
    IronPutDown="iron_out"
    PostFireIdleAnim="Post_fire_idle"
    PostFireIronIdleAnim="iron_shoot_idle"
    BoltHipAnim="Pump_action"
    BoltIronAnim="Iron_pump_action"
    PreReloadAnim="Reload_start"
    SingleReloadAnim="Reload_single_round"
    PostReloadAnim="Reload_end_pump_action"
    SprintStartAnim="sprint_start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="sprint_end"
    // Revert unwanted inherited values from DHSniperWeapon:
    bIsSniper=false
    bSniping=false
    
    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    WeaponComponentAnimations(0)=(DriverType=DRIVER_Bayonet,Channel=1,BoneName="front_loop",Animation="slingbayonet")
    WeaponComponentAnimations(1)=(DriverType=DRIVER_Bolt,Channel=2,BoneName="hammer",Animation="Hammer") // TODO: add animation with 2 frames, 1 where the hammer is forward, and the next where it's fully back
}
