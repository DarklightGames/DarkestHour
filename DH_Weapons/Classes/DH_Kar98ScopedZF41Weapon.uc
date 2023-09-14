//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Kar98ScopedZF41Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Karabiner 98k (ZF41)"
    FireModeClass(0)=class'DH_Weapons.DH_Kar98ScopedZF41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98ScopedZF41MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Kar98ScopedZF41Attachment'
    PickupClass=class'DH_Weapons.DH_Kar98ScopedZF41Pickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.kar98k_zf41_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.k98_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    bForceModelScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
	//ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'  //to do: proper 3d scope texture

    IronSightDisplayFOV=40.0
    IronSightDisplayFOVHigh=40.0 //
    PlayerFOVZoom=37.0
    ScopePortalFOV=2.0     //ZF41: approximately 1.6 degrees FOV and 1.6x zoom
    ScopePortalFOVHigh=2.0
    LensMaterialID=7
    DisplayFOV=84.0
    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true
    ScopeOverlaySize=0.043

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    //BoltHipAnim="bolt_scope"
    PostFireIronIdleAnim=none
    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert_half"
    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"
    PostReloadAnim="single_close"
    
    FullReloadAnim="reload"
}
