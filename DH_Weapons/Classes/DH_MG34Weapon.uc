//=============================================================================
// DH_MG34Weapon
//=============================================================================
// Weapon class for the German MG34 machinegun
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class DH_MG34Weapon extends DH_MGbase;

#exec OBJ LOAD FILE=..\Animations\Axis_Mg34_1st.ukx

// Overriden to prevent the exploit of freezing your animations after firing
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
        FireMode[Mode].bInstantStop = true;
    if (Instigator.IsLocallyControlled() && !FireMode[Mode].bFireOnRelease)
    {
        if (!IsAnimating(0))
        {
            PlayIdle();
        }
    }

    FireMode[Mode].bIsFiring = false;
    FireMode[Mode].StopFiring();
    if (!FireMode[Mode].bFireOnRelease)
        ZeroFlashCount(Mode);
}

defaultproperties
{
     bTrackBarrelHeat=true
     ROBarrelClass=Class'DH_Weapons.DH_MG34Barrel'
     BarrelSteamBone="Barrel"
     BarrelChangeAnim="Bipod_Barrel_Change"
     IdleToBipodDeploy="Rest_2_Bipod"
     BipodDeployToIdle="Bipod_2_Rest"
     BipodHipIdle="Hip_Idle"
     BipodHipToDeploy="Hip_2_Bipod"
     MagEmptyReloadAnim="Bipod_Reload"
     MagPartialReloadAnim="Bipod_Reload"
     IronIdleAnim="Bipod_Idle"
     IronBringUp="Rest_2_Hip"
     IronPutDown="Hip_2_Rest"
     MaxNumPrimaryMags=7
     InitialNumPrimaryMags=7
     bPlusOneLoading=true
     PlayerIronsightFOV=80.000000
     SprintStartAnim="Rest_Sprint_Start"
     SprintLoopAnim="Rest_Sprint_Middle"
     SprintEndAnim="Rest_Sprint_End"
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=45.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     Handtex=Texture'Weapons1st_tex.Arms.hands_gergloves'
     FireModeClass(0)=Class'DH_Weapons.DH_MG34AutoFire'
     FireModeClass(1)=Class'DH_Weapons.DH_MG34SemiAutoFire'
     IdleAnim="Rest_Idle"
     SelectAnim="Draw"
     PutDownAnim="Put_away"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bSniping=true
     DisplayFOV=70.000000
     PickupClass=Class'DH_Weapons.DH_MG34Pickup'
     BobDamping=1.600000
     AttachmentClass=Class'DH_Weapons.DH_MG34Attachment'
     ItemName="Maschinengewehr 34"
     Mesh=SkeletalMesh'Axis_Mg34_1st.MG_34_Mesh'
}
