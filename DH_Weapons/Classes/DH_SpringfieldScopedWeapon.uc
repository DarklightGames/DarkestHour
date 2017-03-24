//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SpringfieldScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Springfield_1st.ukx

defaultproperties
{
    ItemName="M1903 Springfield Scoped"
    FireModeClass(0)=class'DH_Weapons.DH_SpringfieldScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SpringfieldScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SpringfieldScopedAttachment'
    PickupClass=class'DH_Weapons.DH_SpringfieldScopedPickup'

    Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_Scoped'
    Skins(4)=shader'DH_Weapon_tex.Spec_Maps.M1GarandAmmo_s' // TODO: ammo specularity shader isn't used in the anim mesh & should be added there
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.M1919Springfield_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=90.0
    IronSightDisplayFOV=40.0
    PlayerFOVZoom=36.0 // 2.5x
    ScopePortalFOV=7.0
    ScopePortalFOVHigh=13.0
    IronSightDisplayFOVHigh=43.0
    XOffsetHighDetail=(X=-2.0,Y=0.0,Z=0.0)
    ScopeYaw=25
    ScopePitchHigh=20
    ScopeYawHigh=40
    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'
    LensMaterialID=5
    OverlayCorrectionX=-0.5 // correction of textured scope sights

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    PutDownAnim="putaway"
    BoltIronAnim="iron_boltrest"
    PostFireIronIdleAnim="Iron_idlerest"
}
