//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WitchEnder666Weapon extends DHBoltActionWeapon;

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
    ItemName="WitchEnder 666 'Satan's Bane'"
    FireModeClass(0)=Class'DH_WitchEnder666Fire'
    FireModeClass(1)=Class'DH_WitchEnder666MeleeFire'
    AttachmentClass=Class'DH_WitchEnder666Attachment'
    PickupClass=Class'DH_WitchEnder666Pickup'

    Mesh=SkeletalMesh'DH_Winchester1897_anm.WitchEnder666_1st'

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
    
    bHasBayonet=false
    

    WeaponComponentAnimations(0)=(DriverType=DRIVER_Bayonet,Channel=1,BoneName="front_loop",Animation="slingbayonet")
    WeaponComponentAnimations(1)=(DriverType=DRIVER_Bolt,Channel=2,BoneName="hammer",Animation="Hammer")
}
