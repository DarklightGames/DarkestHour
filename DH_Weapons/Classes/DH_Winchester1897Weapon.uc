//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Winchester1897Weapon extends DHBoltActionWeapon;

// Overriden to allow only 5 rounds loaded in one go. The 6th round can be
// loaded once there's a round in the chamber. When reloading with an empty
// chamber, the player would have to manually top up the magazine by initiating
// a second reload.
simulated function int GetMaxLoadedRounds()
{
    return AmmoClass[0].default.InitialAmount - int(bWaitingToBolt);
}

defaultproperties
{
    ItemName="Winchester Model 1897"
    FireModeClass(0)=class'DH_Weapons.DH_Winchester1897Fire'
    FireModeClass(1)=class'DH_Weapons.DH_Winchester1897MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Winchester1897Attachment'
    PickupClass=class'DH_Weapons.DH_Winchester1897Pickup'

    Mesh=SkeletalMesh'DH_Winchester1897_anm.Winchester1897_1st'

    DisplayFOV=90.0
    PlayerIronsightFOV=50.0
    IronSightDisplayFOV=65.0
    BobModifyFactor=0.4

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

    PutDownAnim="putaway"

    IronBringUp="iron_in"
    IronIdleAnim="Iron_idle"
    IronPutDown="iron_out"
    PostFireIdleAnim="Post_fire_idle"
    PostFireIronIdleAnim="iron_shoot_idle"
    BoltHipAnim="Pump_action"
    BoltIronAnim="Iron_pump_action"
    PreReloadAnim="Reload_start"
    SingleReloadAnim="Reload_single_round"
    PostReloadAnim="Reload_end_pump_action"
    PostReloadNoBoltAnim="reload_end"
    SprintStartAnim="sprint_start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="sprint_end"
    // Revert unwanted inherited values from DHSniperWeapon:
    bIsSniper=false
    bSniping=false
    bCanUseUnfiredRounds=false
    bEjectRoundOnReload=false
    
    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    WeaponComponentAnimations(0)=(DriverType=DRIVER_Bayonet,Channel=1,BoneName="front_loop",Animation="slingbayonet")
    WeaponComponentAnimations(1)=(DriverType=DRIVER_Bolt,Channel=2,BoneName="hammer",Animation="Hammer") 
}
