//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BazookaWeapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="M1A1 Bazooka"
    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka_m1a1'
    TeamIndex=1
    FireModeClass(0)=Class'DH_BazookaFire'
    AttachmentClass=Class'DH_BazookaAttachment'
    PickupClass=Class'DH_BazookaPickup'

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    SelectAnim="Draw"
    PutDownAnim="putaway"
    IronIdleAnim="iron_loop"
    IronIdleEmptyAnim="iron_loop"
    IronSightDisplayFOV=70.0
    IronSightDisplayFOVHigh=70.0

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_empty"

    RangeDistanceUnit=DU_Yards
    RangeSettings(0)=(Range=50,FirePitch=165,IronIdleAnim="iron_loop_50",IronFireAnim="iron_shoot_loop_50",AssistedReloadAnim="iron_reload_50")
    RangeSettings(1)=(Range=100,FirePitch=1200,IronIdleAnim="iron_loop_100",IronFireAnim="iron_shoot_loop_100",AssistedReloadAnim="iron_reload_100")
    RangeSettings(2)=(Range=150,FirePitch=3000,IronIdleAnim="iron_loop_150",IronFireAnim="iron_shoot_loop_150",AssistedReloadAnim="iron_reload_150")
}

