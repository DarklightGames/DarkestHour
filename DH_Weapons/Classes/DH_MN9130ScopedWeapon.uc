//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130ScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Nagantscope_1st.ukx

defaultproperties
{
    ItemName="Mosin-Nagant M91/30 PU Sniper"
    FireModeClass(0)=class'DH_Weapons.DH_MN9130ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_MN9130ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MN9130ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_MN9130ScopedPickup'

    Mesh=SkeletalMesh'Allies_Nagantscope_1st.Mosin-Nagant-9130-Scoped-Mesh'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=40.0
    PlayerFOVZoom=24.0
    ZoomOutTime=0.35
    ScopePortalFOV=7.0 // 3.5x
    ScopePortalFOVHigh=15.0 // 3.5x
    IronSightDisplayFOVHigh=43.0
    XOffsetHighDetail=(X=-6.0,Y=0.0,Z=0.0)
    ScopeYaw=25
    ScopePitchHigh=20
    ScopeYawHigh=40
    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
    LensMaterialID=5

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10
}
