//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_30calWeapon extends DHMGWeapon;

defaultproperties
{
    ItemName="M1919A6 Browning Machine Gun"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_30calFire'
    AttachmentClass=class'DH_Weapons.DH_30calAttachment'
    PickupClass=class'DH_Weapons.DH_30calPickup'

    Mesh=SkeletalMesh'DH_M1919_anm.M1919A6_1st'

    DisplayFOV=90.0
    IronSightDisplayFOV=60.0
    PlayerDeployFOV=65.0

    MaxNumPrimaryMags=2
    InitialNumPrimaryMags=2

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_30CalBarrel'
    BarrelSteamBone="MUZZLE_A6"

    PutDownAnim="putaway"
    BipodMagEmptyReloadAnim="reload_empty"
    BipodMagPartialReloadAnim="reload_half"

    BeltBulletClass=class'DH_Weapons.DH_30calBeltRound'
    MGBeltBones(0)="BELT_01"
    MGBeltBones(1)="BELT_02"
    MGBeltBones(2)="BELT_03"
    MGBeltBones(3)="BELT_04"
    MGBeltBones(4)="BELT_05"
    MGBeltBones(5)="BELT_06"
    MGBeltBones(6)="BELT_07"
    MGBeltBones(7)="BELT_08"
    MGBeltBones(8)="BELT_09"
    MGBeltBones(9)="BELT_10"
    MGBeltBones(10)="BELT_11"
    MGBeltBones(11)="BELT_12"
    MGBeltBones(12)="BELT_13"
    MGBeltBones(13)="BELT_14"

    BipodDeployToIdle="undeploy"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    IronIdleAnim="iron_idle"
    IdleAnim="rest_idle"
    
    // Hip Firing
    PlayerIronsightFOV=90.0
    bCanFireFromHip=true
    FreeAimRotationSpeed=2.0

    MuzzleBone="MUZZLE_A6"

    BipodHipToDeploy="Hip_2_Bipod"

    bDoBipodPhysicsSimulation=true
    Begin Object Class=DHBipodPhysicsSettings Name=DH30CalBipodPhysicsSettings
        BarrelBoneName="MUZZLE_A6"
        BipodRollAxis=AXIS_X
        ArmLength=200
    End Object
    BipodPhysicsSettings=DH30CalBipodPhysicsSettings
}
