//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_Kar98ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Karabiner 98k"
    FireModeClass(0)=class'DH_Weapons.DH_Kar98ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Kar98ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_Kar98ScopedPickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.kar98k-scoped-mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.k98_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
	//ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'  //to do: proper 3d scope texture
    DisplayFOV=70.0
    IronSightDisplayFOV=21.7
    IronSightDisplayFOVHigh=21.7
    PlayerFOVZoom=15.0
    ScopePortalFOV=9.0
    ScopePortalFOVHigh=9.0  //very hard to find information on ZF39's field of view, but some places mention 160mm which is roughly 9 degrees
    LensMaterialID=5
    	
    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true
	
    ScopeOverlaySize=0.62

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PostFireIronIdleAnim=none
    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert_half"
    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"
    PostReloadAnim="single_close"
}
