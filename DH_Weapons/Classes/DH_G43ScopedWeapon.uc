//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_G43ScopedWeapon extends DHSniperWeapon;

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

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
	//ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'  //to do: proper 3d scope texture

    DisplayFOV=70.0
    IronSightDisplayFOV=45.0
    IronSightDisplayFOVHigh=45.0
    PlayerFOVZoom=15.0
    ScopePortalFOV=5.4  //4.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    ScopePortalFOVHigh=5.4
    LensMaterialID=4
	
    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true
    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8

    ScopeOverlaySize=0.32


}
