//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Wz35Weapon extends DHBoltActionWeapon;

// Modified to make ironsights key try to deploy/undeploy the bipod
simulated function ROIronSights()
{
    Deploy();
}

defaultproperties
{
    ItemName="Wz-35 Anti-Tank Rifle"
    FireModeClass(0)=class'DH_Weapons.DH_Wz35Fire'
    AttachmentClass=class'DH_Weapons.DH_Wz35Attachment'
    PickupClass=class'DH_Weapons.DH_Wz35Pickup'

    Mesh=SkeletalMesh'DH_Wz35_anm.wz35_1st'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    IronSightDisplayFOV=55

    bCanHaveInitialNumMagsChanged=false
    MaxNumPrimaryMags=20
    InitialNumPrimaryMags=20

    bCanBipodDeploy=true
    bCanRestDeploy=false
    bCanFireFromHip=false
    bMustReloadWithBipodDeployed=true
    bMustFireWhileSighted=true

    SelectAnim="draw"
    PutDownAnim="putaway"
    IdleToBipodDeploy="bipod_in"
    BipodDeployToIdle="bipod_out"
    BoltIronAnim="iron_bolt"
    BipodIdleAnim="iron_idle"
    BipodMagEmptyReloadAnim="reload_empty"
    MagEmptyReloadAnims(0)="reload_empty"

    bShouldZoomWhenBolting=true
}
