//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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

    ScopeOverlay=texture'DH_Weapon_tex.AxisSmallArms.Ger_sniperscope_overlay'
    IronSightDisplayFOV=45.0
    PlayerFOVZoom=22.5
    ScopePortalFOV=7.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8
}
