//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_BrenWeapon extends DHBipodAutoWeapon;

defaultproperties
{
    SwayModifyFactor=1.2 // Increased sway (0.8 is default otherwise)

    ItemName="Bren Mk.IV"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BrenFire'
    FireModeClass(1)=class'DH_Weapons.DH_BrenMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BrenAttachment'
    PickupClass=class'DH_Weapons.DH_BrenPickup'

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_BrenBarrel'
    BarrelSteamBone="Muzzle"

    Mesh=SkeletalMesh'DH_Bren_1st.Bren'
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.BrenGun_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=45.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    bHasSelectFire=true
    SelectFireSound=Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01'

    SightUpIronBringUp="Deploy"
    SightUpIronPutDown="undeploy"
    SightUpIronIdleAnim="deploy_idle"
    SightUpMagEmptyReloadAnim="deploy_reload_empty"
    SightUpMagPartialReloadAnim="deploy_reload_half"
}
