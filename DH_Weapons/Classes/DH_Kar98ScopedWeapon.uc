//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Kar98ScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Kar98_1stt.ukx

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

    IronSightDisplayFOV=45.0
    PlayerFOVZoom=22.5
    ScopePortalFOV=7.0
    ScopePortalFOVHigh=13.0
    IronSightDisplayFOVHigh=43.0
    XOffsetHighDetail=(X=-5.0,Y=0.0,Z=0.0)
    ScopePitch=-10
    ScopeYaw=40
    ScopeYawHigh=35
    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
    LensMaterialID=5

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
}
