//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BrenWeapon extends DHAutoWeapon;

defaultproperties
{
    SwayModifyFactor=1.15 // Increased sway (0.7 is default otherwise)

    ItemName="Bren Mk.II"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BrenFire'
    AttachmentClass=class'DH_Weapons.DH_BrenAttachment'
    PickupClass=class'DH_Weapons.DH_BrenPickup'

    Mesh=SkeletalMesh'DH_ZB_1st.BrenMk2_1st'
    bUseHighDetailOverlayIndex=false
    Skins(0)=Texture'DH_Bren_tex.one.Bren_D'
    HandNum=1
    SleeveNum=2

    DisplayFOV=88.0
    IronSightDisplayFOV=65.0
    PlayerDeployFOV=65

    bHasSelectFire=true
    SelectFireAnim="fireswitch"
    SelectFireIronAnim="iron_fireswitch"
    SelectFireBipodIronAnim="deploy_fireswitch"

    InitialBarrels=2
    BarrelClass=class'DH_Weapons.DH_BrenBarrel'
    BarrelSteamBone="Barrel"

    PlayerIronsightFOV=65.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9
    NumMagsToResupply=2

    IdleToBipodDeploy="deploy"
    BipodDeployToIdle="undeploy"
    BipodIdleAnim="deploy_idle"
    BipodMagEmptyReloadAnim="bipod_reload"
    BipodMagPartialReloadAnim="bipod_reload"

    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    IronToBipodDeploy="iron_deploy"

    IronIdleAnim="iron_Idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    SprintStartAnim="Sprint_Start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="Sprint_End"
    IdleAnim="Idle"
    SelectAnim="Draw"
    PutDownAnim="Putaway"

    FirstSelectAnim="draw1"
    BarrelChangeAnim="BarrelChange"

    bCanBipodDeploy=true
    bCanBeResupplied=true
    ZoomOutTime=0.1

    // Bipod Physics (same as the ZB-30, bones are identical)
    bDoBipodPhysicsSimulation=true
    Begin Object Class=DHBipodPhysicsSettings Name=DHBarBipodPhysicsSettings
        BarrelBoneName="Muzzle"
        BipodBoneName="bipod_base"
        BarrelRollAxis=AXIS_X
        BarrelPitchAxis=AXIS_Y
        BarrelBoneRotationOffset=(Roll=-16384)
        AngleFactor=-1.0    // the bone is inverted, so we flip the angle
    End Object
    BipodPhysicsSettings=DHBarBipodPhysicsSettings
}
