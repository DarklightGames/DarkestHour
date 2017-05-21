//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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

    ScopeOverlay=texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
    IronSightDisplayFOV=40.0
    PlayerFOVZoom=24.0
    ScopePortalFOV=7.0 // 3.5x
    ZoomOutTime=0.35

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10
}
