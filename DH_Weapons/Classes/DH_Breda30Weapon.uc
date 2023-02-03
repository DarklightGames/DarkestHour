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
    MagazineAnimations(0)=(Channel=1,BoneName="magazine_internals",Animation="magazine_animation")

    BeltBulletClass=class'DH_Weapons.DH_Breda30FPAmmoRound'
    MGBeltBones(0)="MAGAZINE_BULLET_01"
    MGBeltBones(1)="MAGAZINE_BULLET_02"
    MGBeltBones(2)="MAGAZINE_BULLET_03"
    MGBeltBones(3)="MAGAZINE_BULLET_04"
    MGBeltBones(4)="MAGAZINE_BULLET_05"
    MGBeltBones(5)="MAGAZINE_BULLET_06"
    MGBeltBones(6)="MAGAZINE_BULLET_07"
    MGBeltBones(7)="MAGAZINE_BULLET_08"
    MGBeltBones(8)="MAGAZINE_BULLET_09"
    MGBeltBones(9)="MAGAZINE_BULLET_10"
    MGBeltBones(10)="MAGAZINE_BULLET_11"
    MGBeltBones(11)="MAGAZINE_BULLET_12"
    MGBeltBones(12)="MAGAZINE_BULLET_13"
    MGBeltBones(13)="MAGAZINE_BULLET_14"
    MGBeltBones(14)="MAGAZINE_BULLET_15"
    MGBeltBones(15)="MAGAZINE_BULLET_16"
    MGBeltBones(16)="MAGAZINE_BULLET_17"
    MGBeltBones(17)="MAGAZINE_BULLET_18"
    MGBeltBones(18)="MAGAZINE_BULLET_19"
    MGBeltBones(19)="MAGAZINE_BULLET_20"

    // TODO: the bullet code from the MGs needs to be moved to DHProjectileWeapon as well.

    ItemName="Breda modello 30"
    TeamIndex=0 // TODO: weapons "belonging" to teams is a flawed concept with the introduction of the Italians.
    FireModeClass(0)=class'DH_Weapons.DH_Breda30Fire'
    AttachmentClass=class'DH_Weapons.DH_Breda30Attachment'
    PickupClass=class'DH_Weapons.DH_Breda30Pickup'

    Mesh=SkeletalMesh'DH_Breda30_anm.Breda30_1st'
    bUseHighDetailOverlayIndex=false

    DisplayFOV=90.0
    IronSightDisplayFOV=60.0
    PlayerIronsightFOV=60.0
    PlayerDeployFOV=60.0

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

    SprintStartAnimRate=1.0
    SprintEndAnimRate=1.0
}
