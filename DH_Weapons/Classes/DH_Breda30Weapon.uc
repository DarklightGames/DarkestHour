//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Breda30Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Breda modello 30"
    TeamIndex=0 // TODO: weapons "belonging" to teams is a flawed concept with the introduction of the Italians.
    FireModeClass(0)=class'DH_Weapons.DH_Breda30Fire'
    AttachmentClass=class'DH_Weapons.DH_Breda30Attachment'
    PickupClass=class'DH_Weapons.DH_Breda30Pickup'

    Mesh=SkeletalMesh'DH_ZB_1st.BrenMk2_1st'    // TDOO: replace
    bUseHighDetailOverlayIndex=false

    DisplayFOV=90.0
    IronSightDisplayFOV=65.0
    PlayerDeployFOV=65

    bHasSelectFire=false

    bHasSpareBarrel=true
    InitialBarrels=3    // The backpack has slots on the side for two spare barrels.
    BarrelClass=class'DH_Weapons.DH_Breda30Barrel'
    BarrelSteamBone="barrel"
    BarrelChangeAnim="barrel_change"

    PlayerIronsightFOV=65.0

    MaxNumPrimaryMags=15        // The backpack that the machine-gunner carries holds 15 slots for stripper clips.
    InitialNumPrimaryMags=10
    NumMagsToResupply=2

    IdleToBipodDeploy="deploy"
    BipodDeployToIdle="undeploy"
    BipodIdleAnim="deploy_idle"
    BipodMagEmptyReloadAnim="bipod_reload"
    BipodMagPartialReloadAnim="bipod_reload"

    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    IronToBipodDeploy="iron_deploy"

    IronIdleAnim="iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    SprintStartAnim="sprint_start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="sprint_end"
    IdleAnim="idle"
    SelectAnim="draw"
    PutDownAnim="putaway"

    FirstSelectAnim="draw"

    bCanBipodDeploy=true
    bCanBeResupplied=true
    ZoomOutTime=0.1
}
