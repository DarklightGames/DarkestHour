//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_MN9130ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Mosin-Nagant M91/30 PU Sniper"
    SwayModifyFactor=0.68 // +0.08
    FireModeClass(0)=class'DH_Weapons.DH_MN9130ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_MN9130ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MN9130ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_MN9130ScopedPickup'

    Mesh=SkeletalMesh'Allies_Nagantscope_1st.Mosin-Nagant-9130-Scoped-Mesh'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
	//ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay' //to do: proper 3d scope texture

    ScopeOverlaySize=0.29 // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
    DisplayFOV=70.0        

    IronSightDisplayFOV=42.5
    IronSightDisplayFOVHigh=42.5
	
    PlayerIronsightFOV=60.0

    PlayerFOVZoom=17.143 // 3.5x // The PlayerFOV the player's FOV will change too when using scoped weapons
    ScopePortalFOV=5.4
    ScopePortalFOVHigh=5.4  //4.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    LensMaterialID=5
    bUsesIronsightFOV=true

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PreReloadAnim="single_open"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}
