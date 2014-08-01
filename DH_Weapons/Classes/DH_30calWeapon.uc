//=============================================================================
// DH_30calWeapon
//=============================================================================

class DH_30calWeapon extends DH_MGbase;

#exec OBJ LOAD FILE=..\Animations\DH_30Cal_1st.ukx

var     ROFPAmmoRound       MGBeltArray[10];    // An array of first person ammo rounds
var     name                MGBeltBones[10];    // An array of bone names to attach the belt to
var() class<ROFPAmmoRound>  BeltBulletClass;    // The class to spawn for each bullet on the ammo belt

//=============================================================================
// functions
//=============================================================================

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.Netmode != NM_DedicatedServer)
    {
        SpawnAmmoBelt();
    }
}

// Handles making ammo belt bullets disappear
simulated function UpdateAmmoBelt()
{
    local int i;

    if (AmmoAmount(0) > 9)
    {
        return;
    }

    for (i = AmmoAmount(0); i < ArrayCount(MGBeltArray); i++)
    {
        MGBeltArray[i].SetDrawType(DT_none);
    }
}

// Spawn the first person linked ammobelt
simulated function SpawnAmmoBelt()
{
    local int i;

    for (i = 0; i < ArrayCount(MGBeltArray); i++)
    {
        MGBeltArray[i] = Spawn(BeltBulletClass,self);

        AttachToBone(MGBeltArray[i], MGBeltBones[i]);
    }
}

// Make the full ammo belt visible again. Called by anim notifies
simulated function RenewAmmoBelt()
{
    local int i;

    for (i = 0; i < ArrayCount(MGBeltArray); i++)
    {
        MGBeltArray[i].SetDrawType(DT_StaticMesh);
    }
}

defaultproperties
{
     MGBeltBones(0)="Case09"
     MGBeltBones(1)="Case08"
     MGBeltBones(2)="Case07"
     MGBeltBones(3)="Case06"
     MGBeltBones(4)="Case05"
     MGBeltBones(5)="Case04"
     MGBeltBones(6)="Case03"
     MGBeltBones(7)="Case02"
     MGBeltBones(8)="Case01"
     MGBeltBones(9)="Case"
     BeltBulletClass=Class'DH_Weapons.DH_30calBeltRound'
     bTrackBarrelHeat=true
     bCanFireFromHip=false
     InitialBarrels=1
     ROBarrelClass=Class'DH_Weapons.DH_30CalBarrel'
     BarrelSteamBone="bipod"
     IdleToBipodDeploy="Rest_2_Bipod"
     BipodDeployToIdle="Bipod_2_Rest"
     MagEmptyReloadAnim="Reload"
     MagPartialReloadAnim="Reload"
     IronIdleAnim="Bipod_Idle"
     IronBringUp="Rest_2_Bipod"
     IronPutDown="Bipod_2_Rest"
     MaxNumPrimaryMags=3
     InitialNumPrimaryMags=3
     bPlusOneLoading=true
     SprintStartAnim="Rest_Sprint_Start"
     SprintLoopAnim="Rest_Sprint_Middle"
     SprintEndAnim="Rest_Sprint_End"
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=35.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FireModeClass(0)=Class'DH_Weapons.DH_30calFire'
     FireModeClass(1)=Class'ROInventory.ROEmptyFireClass'
     IdleAnim="Rest_Idle"
     SelectAnim="Draw"
     PutDownAnim="putaway"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bSniping=true
     DisplayFOV=70.000000
     PickupClass=Class'DH_Weapons.DH_30calPickup'
     BobDamping=1.600000
     AttachmentClass=Class'DH_Weapons.DH_30calAttachment'
     ItemName="M1919A4 Browning Machine Gun"
     Mesh=SkeletalMesh'DH_30Cal_1st.30Cal'
}

