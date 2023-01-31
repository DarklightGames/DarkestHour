//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Breda30Weapon extends DHAutoWeapon;

// TODO: make this a generic part of projectileweapon class
simulated function ROIronSights()
{
    Deploy();
}

defaultproperties
{
    ItemName="Breda modello 30"
    TeamIndex=0 // TODO: weapons "belonging" to teams is a flawed concept with the introduction of the Italians.
    FireModeClass(0)=class'DH_Weapons.DH_Breda30Fire'
    AttachmentClass=class'DH_Weapons.DH_Breda30Attachment'
    PickupClass=class'DH_Weapons.DH_Breda30Pickup'

    Mesh=SkeletalMesh'DH_Breda30_anm.Breda30_1st'
    bUseHighDetailOverlayIndex=false

    DisplayFOV=90.0
    IronSightDisplayFOV=65.0
    PlayerIronsightFOV=65.0
    PlayerDeployFOV=65.0

    bHasSelectFire=false

    bHasSpareBarrel=true
    InitialBarrels=3    // The backpack has slots on the side for two spare barrels.
    BarrelClass=class'DH_Weapons.DH_Breda30Barrel'
    BarrelSteamBone="muzzle"
    BarrelChangeAnim="barrel_change"

    MaxNumPrimaryMags=15        // The backpack that the machine-gunner carries holds 15 slots for stripper clips.
    InitialNumPrimaryMags=10
    NumMagsToResupply=2

    IdleToBipodDeploy="deploy"
    BipodDeployToIdle="undeploy"
    BipodIdleAnim="deploy_idle"
    BipodMagEmptyReloadAnim="reload"
    BipodMagPartialReloadAnim="reload"

    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    IronToBipodDeploy="iron_deploy"

    SprintStartAnim="sprint_start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="sprint_end"
    IdleAnim="idle"
    SelectAnim="draw"
    PutDownAnim="putaway"

    bCanBipodDeploy=true
    bCanBeResupplied=true
    bMustReloadWithBipodDeployed=true
    ZoomOutTime=0.1
}
