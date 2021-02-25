//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_SVT40ScopedWeapon extends DHSniperWeapon;

defaultproperties
{
    ItemName="SVT-40 Scoped"
    FireModeClass(0)=class'DH_Weapons.DH_SVT40ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SVT40ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_SVT40ScopedPickup'

    Mesh=SkeletalMesh'DH_Svt40_1st.svt40_scoped_1st'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.svt40_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    ScopeOverlaySize=0.29

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
    //ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'  //to do: proper 3d scope texture

    IronSightDisplayFOV=44.4
    IronSightDisplayFOVHigh=44.4
    DisplayFOV=85.0
    PlayerIronsightFOV=60.0
    PlayerFOVZoom=17.143 // 3.5x
    ScopePortalFOV=5.4  //4.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    ScopePortalFOVHigh=5.4
    bUsesIronsightFOV=true

    LensMaterialID=4

    InitialNumPrimaryMags=7
    MaxNumPrimaryMags=7
}
