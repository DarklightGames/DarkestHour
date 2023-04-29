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
    AttachmentClass=class'DH_Weapons.DH_PTRDAttachment'
    PickupClass=class'DH_Weapons.DH_PTRDPickup'

    Mesh=SkeletalMesh'DH_Wz35.Ws35_mesh'
    // HighDetailOverlay=Shader'Weapons1st_tex.Rifles.PTRD_S'
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

    SelectAnim="Draw"
    PutDownAnim="Put_away"

    MagEmptyReloadAnims(0)="Reload"
   
    IdleToBipodDeploy="bipod_in"
    // BipodDeployToIdle="bipod_out"
    BoltIronAnim="iron_bolt"
    BipodIdleAnim="iron_idle"
    BipodMagEmptyReloadAnim="Reload"

    bShouldZoomWhenBolting=true
}
