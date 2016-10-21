//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_G43ScopedWeapon extends DHSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_G43_1st.ukx

defaultproperties
{
    ItemName="Gewehr 43"
    FireModeClass(0)=class'DH_Weapons.DH_G43ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_G43MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_G43ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_G43ScopedPickup'

    Mesh=SkeletalMesh'Axis_G43_1st.g43_scoped_mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.g43_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=45.0
    PlayerFOVZoom=22.5

    ScopePortalFOV=7.0
    ScopePortalFOVHigh=13.0
    IronSightDisplayFOVHigh=25.0
    ScopePitch=-10
    ScopeYaw=40
    ScopeYawHigh=35
    TexturedScopeTexture=texture'DH_Weapon_tex.AxisSmallArms.Ger_sniperscope_overlay'
    LensMaterialID=4

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8
}
