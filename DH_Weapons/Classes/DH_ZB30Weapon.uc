//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_ZB30Weapon extends DHAutoWeapon;

defaultproperties
{
    SwayModifyFactor=1.1 // Increased sway because of length, weight, and general awkwardness

    ItemName="ZB vz.30 Machine Gun"

    FireModeClass(0)=class'DH_Weapons.DH_ZB30AutoFire'
    AttachmentClass=class'DH_Weapons.DH_ZB30Attachment'
    PickupClass=class'DH_Weapons.DH_ZB30Pickup'

    Mesh=SkeletalMesh'DH_ZB_1st.ZB30_1st'
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=0
    Skins(0)=Texture'DH_Weapon_CC_tex.SmallArms.ZB30_diffuse'
    Skins(1)=Shader'Weapons1st_tex.Bullets.kar98k_stripper_s'
    HandNum=2
    SleeveNum=3

    DisplayFOV=85.0
    IronSightDisplayFOV=60.0
    PlayerDeployFOV=65

    bHasSelectFire=true
    SelectFireAnim="fireswitch"
    SelectFireIronAnim="iron_fireswitch"
    SelectFireBipodIronAnim="deploy_fireswitch"

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12
    NumMagsToResupply=3

    InitialBarrels=2
    BarrelClass=class'DH_Weapons.DH_ZB30Barrel'
    BarrelSteamBone="Barrel"

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

    // Bipod Physics
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
