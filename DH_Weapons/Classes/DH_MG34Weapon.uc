//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MG34Weapon extends DHMGWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Mg34_1st.ukx

// Overridden to prevent the exploit of freezing your animations after firing
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
    {
        FireMode[Mode].bInstantStop = true;
    }

    if (Instigator.IsLocallyControlled() && !FireMode[Mode].bFireOnRelease && !IsAnimating(0))
    {
        PlayIdle();
    }

    FireMode[Mode].bIsFiring = false;
    FireMode[Mode].StopFiring();

    if (!FireMode[Mode].bFireOnRelease)
    {
        ZeroFlashCount(Mode);
    }
}

defaultproperties
{
    InitialBarrels=2
    BarrelClass=class'DH_Weapons.DH_MG34Barrel'
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
    PlayerIronsightFOV=90.0
    SprintStartAnim="Rest_Sprint_Start"
    SprintLoopAnim="Rest_Sprint_Middle"
    SprintEndAnim="Rest_Sprint_End"
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=45.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    Handtex=texture'Weapons1st_tex.Arms.hands_gergloves'
    FireModeClass(0)=class'DH_Weapons.DH_MG34AutoFire'
    FireModeClass(1)=class'DH_Weapons.DH_MG34SemiAutoFire' // This econdary fire mode is not a switch, it is done with another button
    IdleAnim="Rest_Idle"
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
    DisplayFOV=70.0
    PickupClass=class'DH_Weapons.DH_MG34Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_MG34Attachment'
    ItemName="Maschinengewehr 34"
    Mesh=SkeletalMesh'DH_Mg34_1st.MG_34_Mesh'
}
