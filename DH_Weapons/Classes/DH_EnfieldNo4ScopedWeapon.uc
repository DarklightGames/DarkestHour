//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_EnfieldNo4ScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_EnfieldNo4_1st.ukx

defaultproperties
{
    ItemName="Scoped Enfield No.4"
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo4ScopedPickup'

    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4_Scoped'
    Skins(4)=shader'Weapons1st_tex.Bullets.kar98k_stripper_s' // TODO: ammo specularity shader isn't used in the anim mesh & should be added there
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.No4MainSniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    ScopeOverlay=texture'DH_Weapon_tex.Scopes.EnfieldNo4_Scope_Overlay'
    OverlayCorrectionX=-8.0
    DisplayFOV=85.0
    IronSightDisplayFOV=40.0
    PlayerFOVZoom=25.714285 // 3.5x
    ScopePortalFOV=7.0

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    bTwoMagsCapacity=true

    PutDownAnim="putaway"
    BoltIronAnim="iron_boltrest"
    PostFireIronIdleAnim="Iron_idle"
}
