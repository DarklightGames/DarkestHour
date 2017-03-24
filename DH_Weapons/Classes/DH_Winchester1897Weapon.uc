//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Winchester1897Weapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Winchester1897_1st.ukx

// This obviously isn't a bolt-action sniper rifle, but extending DHBoltSniperWeapon gives us most of the functionality we need:
// 1) The pump action after firing is equivalent to bolting a rifle, i.e. a 2nd 'fire' press is required to work the post-fire action
// 2) The shotgun is loaded one round at a time & reload can be interrupted by again pressing fire (just like a bolt sniper rifle)
// We just have to neutralise the inherited scope functionality, which is easy

// Empty out or revert unwanted inherited functions from DHSniperWeapon class:
simulated function PostBeginPlay() { super(DHProjectileWeapon).PostBeginPlay(); }
simulated function Destroyed() { super(DHProjectileWeapon).Destroyed(); }
simulated event RenderOverlays(Canvas Canvas) { super(DHProjectileWeapon).RenderOverlays(Canvas); }
simulated event RenderTexture(ScriptedTexture Tex);
simulated function bool ShouldDrawPortal() { return false; }
simulated function UpdateScopeMode();
simulated function PreTravelCleanUp();
simulated function ClearScopeObjects();

defaultproperties
{
    ItemName="Winchester Model 1897"
    FireModeClass(0)=class'DH_Weapons.DH_Winchester1897Fire'
    FireModeClass(1)=class'DH_Weapons.DH_Winchester1897MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Winchester1897Attachment'
    PickupClass=class'DH_Weapons.DH_Winchester1897Pickup'

    Mesh=SkeletalMesh'DH_Winchester1897_1st.Winchester1897'

    DisplayFOV=80
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=50.0
    BobModifyFactor=0.4

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

    IronBringUp="iron_in"
//  IronBringUpRest="Post_fire_iron_in" // TODO: ideally should have this, with hammer up after firing (played when ironsighting while waiting to work the pump action)
    IronIdleAnim="Iron_idle"
    IronPutDown="iron_out"
    PostFireIdleAnim="Post_fire_idle"
    PostFireIronIdleAnim="Post_fire_iron_idle"
    BoltHipAnim="Pump_action"
    BoltIronAnim="Iron_pump_action"
    PreReloadAnim="Reload_start"
    SingleReloadAnim="Reload_single_round"
    PostReloadAnim="Reload_end_pump_action"

    // Revert unwanted inherited values from DHSniperWeapon:
    bIsSniper=false
    bSniping=false
    ScriptedTextureFallback=none
}
