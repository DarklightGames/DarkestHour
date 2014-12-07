//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MG42Weapon extends DH_MGbase;

#exec OBJ LOAD FILE=..\Animations\Axis_Mg42_1st.ukx

// Overriden so we do faster net updated when we're down to the last few rounds
simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
    if (AmmoAmount(0) < 11)
    {
        NetUpdateTime = Level.TimeSeconds - 1;
    }

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
    BeltBulletClass=class'ROInventory.MG42BeltRound'
    bTrackBarrelHeat=true
    bCanFireFromHip=false
    BarrelClass=class'DH_Weapons.DH_MG42Barrel'
    BarrelSteamBone="Barrel_Switch"
    BarrelChangeAnim="Bipod_Barrel_Change"
    IdleToBipodDeploy="Rest_2_Bipod"
    BipodDeployToIdle="Bipod_2_Rest"
    MagEmptyReloadAnim="Reload"
    MagPartialReloadAnim="Reload"
    IronIdleAnim="Bipod_Idle"
    IronBringUp="Rest_2_Bipod"
    IronPutDown="Bipod_2_Rest"
    MaxNumPrimaryMags=2
    InitialNumPrimaryMags=2
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
    FireModeClass(0)=class'DH_Weapons.DH_MG42Fire'
    FireModeClass(1)=class'ROInventory.ROEmptyFireclass'
    IdleAnim="Rest_Idle"
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.400000
    CurrentRating=0.400000
    bSniping=true
    DisplayFOV=70.000000
    PickupClass=class'DH_Weapons.DH_MG42Pickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_MG42Attachment'
    ItemName="Maschinengewehr 42"
    Mesh=SkeletalMesh'Axis_Mg42_1st.MG42_Mesh'
}
