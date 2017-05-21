//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_SVT40ScopedWeapon extends DHSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Svt40_1st.ukx

defaultproperties
{
    ItemName="SVT-40 Scoped"
    FireModeClass(0)=class'DH_Weapons.DH_SVT40ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SVT40ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_SVT40ScopedPickup'

    Mesh=SkeletalMesh'Allies_Svt40_1st.svt40_scoped_mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.svt40_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    ScopeOverlay=texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
    IronSightDisplayFOV=60.0
    PlayerFOVZoom=24.0 // 3.5x
    ScopePortalFOV=8.0 // 3.5x

    InitialNumPrimaryMags=6
    MaxNumPrimaryMags=6
}
