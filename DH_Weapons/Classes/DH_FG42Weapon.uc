//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_FG42Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Fallschirmjägergewehr 42"
    TeamIndex=0
    FireModeClass(0)=class'DH_Weapons.DH_FG42Fire'
    FireModeClass(1)=class'DH_Weapons.DH_FG42MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_FG42Attachment'
    PickupClass=class'DH_Weapons.DH_FG42Pickup'

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_FG42Barrel'
    BarrelSteamBone="Muzzle"

    Mesh=SkeletalMesh'DH_Fallschirmgewehr42_1st.FG42' // TODO: there is no specularity mask for this weapon

    IronSightDisplayFOV=50.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11

    bHasSelectFire=true

    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    SelectFireBipodIronAnim="deploy_switch_fire"
    IdleToBipodDeploy="Deploy"
    BipodDeployToIdle="undeploy"
    BipodIdleAnim="deploy_idle"
    BipodMagEmptyReloadAnim="deploy_reload_empty"
    BipodMagPartialReloadAnim="deploy_reload_half"

    bCanBipodDeploy=true
    ZoomOutTime=0.1
    PutDownAnim="putaway"
}
