//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_STG44ScopedWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Sturmgewehr 44 (ZF4)"
    FireModeClass(0)=class'DH_Weapons.DH_STG44ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_STG44ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_STG44ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_STG44ScopedPickup'

    Mesh=SkeletalMesh'DH_Stg44_1st.STG44-Scoped'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.STG44_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
    //ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'  //to do: proper 3d scope texture
    bIsSniper=true
    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.85
    LensMaterialID=4
    PlayerFOVZoom=15.0
    ScopePortalFOV=5.4  //4.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    ScopePortalFOVHigh=5.4
    ScopeOverlaySize=0.32
    SwayModifyFactor=0.83 // scope makes it slightly heavier
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=41.6
    IronSightDisplayFOVHigh=41.6
    DisplayFOV=90.0
    ZoomOutTime=0.1

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"

    bSniping=true // for bots (as has longer range than other auto weapons)
    AIRating=0.4
    CurrentRating=0.4

}
