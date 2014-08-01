//=============================================================================
// DH_MG42Weapon
//=============================================================================
// Weapon class for the German MG42 machinegun
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_MG42Weapon extends DH_MGbase;

#exec OBJ LOAD FILE=..\Animations\Axis_Mg42_1st.ukx

var 	ROFPAmmoRound   	MGBeltArray[10];	// An array of first person ammo rounds
var 	name   				MGBeltBones[10];	// An array of bone names to attach the belt to
var() class<ROFPAmmoRound> 	BeltBulletClass;    // The class to spawn for each bullet on the ammo belt

//=============================================================================
// functions
//=============================================================================

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Level.Netmode != NM_DedicatedServer)
		SpawnAmmoBelt();
}

// Handles making ammo belt bullets disappear
simulated function UpdateAmmoBelt()
{
	local int i;

	if (AmmoAmount(0) > 9)
	{
		return;
	}

    for (i=AmmoAmount(0); i<10; i++)
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

// Overriden so we do faster net updated when we're down to the last few rounds
simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
	if (AmmoAmount(0) < 11)
		NetUpdateTime = Level.TimeSeconds - 1;

	return super.ConsumeAmmo(Mode, load, bAmountNeededIsMax);
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
     BeltBulletClass=Class'ROInventory.MG42BeltRound'
     bTrackBarrelHeat=true
     bCanFireFromHip=false
     ROBarrelClass=Class'DH_Weapons.DH_MG42Barrel'
     BarrelSteamBone="Barrel_Switch"
     BarrelChangeAnim="Bipod_Barrel_Change"
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
     IronSightDisplayFOV=40.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     Handtex=Texture'Weapons1st_tex.Arms.hands_gergloves'
     FireModeClass(0)=Class'DH_Weapons.DH_MG42Fire'
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
     PickupClass=Class'DH_Weapons.DH_MG42Pickup'
     BobDamping=1.600000
     AttachmentClass=Class'DH_Weapons.DH_MG42Attachment'
     ItemName="Maschinengewehr 42"
     Mesh=SkeletalMesh'Axis_Mg42_1st.MG42_Mesh'
}
